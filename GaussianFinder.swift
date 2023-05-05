//
//  GaussianFinder.swift
//  Gaussian Final Project
//
//  Created by IIT PHYS 440 on 4/28/23.
//

import SwiftUI

class GaussianFinder: ObservableObject {
    @ObservedObject var mysuminstance = SumFinder()
    @ObservedObject var myequationinstance = BaselineGaussianEquations()
    

    @Published var TestString = ""
    @Published var Istring = ""
    @Published var Sxstring = ""
    @Published var Systring = ""
    @Published var Astring = ""
    @Published var Bstring = ""
    @Published var xstring = ""
    @Published var ystring = ""
    @Published var numstring = ""
    @Published var mystring = ""
    
    @Published var Iteststring = "1.0"
    @Published var Itruestring = "1.0"
    
// graph changes upon start up to ellipsoidal when these are changed in the code, but they don't change when they are edited in text box. 
    @Published var Sxteststring = "1.3"
    @Published var Syteststring = "1.3"
    
     var Sxtruestring = "1.3"
     var Sytruestring = "1.3"
    
    @Published var Ateststring = "0.006"
    @Published var Bteststring = "0.006"
    
    @Published var Atruestring = "0.006"
    @Published var Btruestring = "0.006"
    
    @Published var xteststring = "7.0"
    @Published var yteststring = "7.0"
    
    @Published var xtruestring = "7.0"
    @Published var ytruestring = "7.0"
    var foundParameters :[Double] = []
    
    func TestingGaussian() -> [Double]
    {
        let I_true = Double(Itruestring)!
        var Intensity = Double(Iteststring)!

        let width = 15
        let height = 15
        var numloop = 0.0
       // var Intensity = 1.5
        var Sigmax = Double(Sxteststring)!
        var Sigmay = Double(Syteststring)!
        let sigx_true = Double(Sxtruestring)!
        let sigy_true = Double(Sytruestring)!
        
        
        var x_0 = Double(xteststring)!
        var y_0 = Double(yteststring)!
        let x_0true = Double(xtruestring)!
        let y_0true = Double(ytruestring)!
        
        var A = Double(Ateststring)!
        var B = Double(Bteststring)!
        let Atrue = Double(Atruestring)!
        let Btrue = Double(Btruestring)!
        //tolerances are very low, it can't handle too big of a spread, or else it finds a false minimum to fall into.
        //things still to do: optimize the code more, seperate it into instances.

        var minimized = true
        let TestingValues = myequationinstance.TiltedGaussian(I_0: I_true, A: Atrue, B: Btrue, x_0: x_0true, y_0: y_0true, sigma_x: sigx_true, sigma_y: sigy_true, width: width, height: width)
        //this is the Intensity that the function below is testing against, to find the least squares. In the IPRO code, this would be removed,and it would be instead testing against the raw data.
        let Istep = 0.01
        let Sxstep = 0.01
        let Systep = 0.01
        let x0step = 0.01
        let y0step = 0.01
        let Astep = 0.0001
        let Bstep = 0.0001
        
        while minimized{
            //3x3x3x3x3x3x3 matrix
           let SumArray = mysuminstance.Sumfinder(Intensity: Intensity, A: A, B: B, x_0: x_0, y_0: y_0, Sigmax: Sigmax, Sigmay: Sigmay, width: width, height: height, Istep: Istep, Sxstep: Sxstep, Systep: Systep, x0step: x0step, y0step: y0step, Astep: Astep, Bstep: Bstep, TestingValues: TestingValues)
            
         
            
            
            
            numloop = numloop + 1
            print(Intensity, Sigmax, x_0, y_0, Sigmay, A, B)
            
            //tolerance is controlled here, tolerance value needs to increase (accuracy decrease) with more variables.
            if SumArray[1][1][1][1][1][1][1] <= 0.008{
                minimized = false
                 foundParameters = []
                Istring = String(format: "central intensity= %.2f.", Intensity)
                Sxstring = String(format: "sigma_x^2= %.1f.", Sigmax)
                Systring = String(format: "sigma_y^2= %.1f.", Sigmay)
                Astring = String(format: "A = %.3f.", A)
                Bstring = String(format: "B = %.3f.", B)
                xstring = String(format: "x= %.2f.", x_0)
                ystring = String(format: "y = %.2f.", y_0)
                self.numstring = "\(numloop) loops to get here!"
                
                foundParameters.append(Intensity)
                foundParameters.append(Sigmax)
                foundParameters.append(Sigmay)
                foundParameters.append(A)
                foundParameters.append(B)
                foundParameters.append(x_0)
                foundParameters.append(y_0)
                
                return foundParameters
                }
            //if dR/dI is negative/postive over a certain tolerance, increase/decrease Intensity accordingly. Same for sigma and dr/dsigma.
            var I_derivative = 0.0
            var sigx_derivative = 0.0
            var sigy_derivative = 0.0
            var x_derivative = 0.0
            var y_derivative = 0.0
            var A_derivative = 0.0
            var B_derivative = 0.0

            //numerical derivation for each of the 7 variables in the tilted gaussian profile.
               I_derivative = (SumArray[2][1][1][1][1][1][1] - SumArray[0][1][1][1][1][1][1]) / Istep
            sigx_derivative = (SumArray[1][2][1][1][1][1][1] - SumArray[1][0][1][1][1][1][1]) / Sxstep
               x_derivative = (SumArray[1][1][2][1][1][1][1] - SumArray[1][1][0][1][1][1][1]) / x0step
            sigy_derivative = (SumArray[1][1][1][2][1][1][1] - SumArray[1][1][1][0][1][1][1]) / Systep
               y_derivative = (SumArray[1][1][1][1][2][1][1] - SumArray[1][1][1][1][0][1][1]) / y0step
               A_derivative = (SumArray[1][1][1][1][1][2][1] - SumArray[1][1][1][1][1][0][1]) / Astep
               B_derivative = (SumArray[1][1][1][1][1][1][2] - SumArray[1][1][1][1][1][1][0]) / Bstep
            
            //could do a for loop for this if they were stored in an array, but don't have time to do that. 
            if I_derivative > 0.0 {
                Intensity = Intensity - Istep
            }
            if I_derivative < 0.0 {
                Intensity = Intensity + Istep
            }
            if sigx_derivative > 0 {
                Sigmax = Sigmax - Sxstep
            }
            if sigx_derivative < 0 {
                Sigmax = Sigmax + Sxstep
            }
            
            if sigy_derivative > 0 {
                Sigmay = Sigmay - Systep
            }
            if sigy_derivative < 0 {
                Sigmay = Sigmay + Systep
            }
            if x_derivative > 0{
                x_0 = x_0 - x0step
            }
            if x_derivative < 0{
                x_0 = x_0 + x0step
            }
            if y_derivative > 0{
                y_0 = y_0 - y0step
            }
            if y_derivative < 0{
                y_0 = y_0 + y0step
            }
            if A_derivative > 0{
                A = A - Astep
            }
            if A_derivative < 0{
                A = A + Astep
            }
            if B_derivative > 0{
                B = B - Bstep
            }
            if B_derivative < 0{
                B = B + Bstep
            }

        }

    }
}
