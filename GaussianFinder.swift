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
    
    @Published var Iteststring = "1.0"
    @Published var Itruestring = "1.0"

    @Published var Sxteststring = "1.3"
    @Published var Syteststring = "1.3"
    
    @Published var Sxtruestring = "1.3"
    @Published var Sytruestring = "1.3"
    
    @Published var Ateststring = "0.006"
    @Published var Bteststring = "0.006"
    
    @Published var Atruestring = "0.006"
    @Published var Btruestring = "0.006"
    
    @Published var xteststring = "7.0"
    @Published var yteststring = "7.0"
    
    @Published var xtruestring = "7.0"
    @Published var ytruestring = "7.0"
    var foundParameters :[Double] = []
    
    func TestingGaussian() -> [Double]{
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
        while minimized{
            //3x3x3x3x3x3x3 matrix
          // var SumArray = Array(repeating: Array(repeating: Array(repeating: Array(repeating: Array(repeating: Array(repeating: Array(repeating: 0.0, count: 3), count: 3), count: 3), count: 3), count: 3), count: 3), count: 3)
            let h = 0.01
            let k = 0.01
            let f = 0.01
            let l = 0.01
            let m = 0.01
            let n = 0.0001
            let o = 0.0001
            var sum = 0.0
           let SumArray = mysuminstance.Sumfinder(Intensity: Intensity, A: A, B: B, x_0: x_0, y_0: y_0, Sigmax: Sigmax, Sigmay: Sigmay, width: width, height: height, Istep: h, Sxstep: k, Systep: l, x0step: f, y0step: m, Astep: n, Bstep: o, TestingValues: TestingValues)
            numloop = numloop + 1
            print(Intensity, Sigmax, x_0, y_0, Sigmay, A, B) //this keeps running for some reason???
            
            //tolerance is controlled here, tolerance value needs to increase (accuracy decrease) with more variables.
            if SumArray[1][1][1][1][1][1][1] <= 0.005{
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

            //sum needs to be the entirety of the x=15 width, or it does not work. So i would need to do a small loop, for the x width, for the four values of (I-H, S), (I+H, S), (I+H, S+K), and (I, S+K). do those sums, and find the slope of those sums relative to each other.

            //use only two derivatives. if dR/dI is negative/postive over a certain tolerance, increase/decrease Intensity accordingly. Same for sigma and dr/dsigma.
            var I_derivative = 0.0
            var sigx_derivative = 0.0
            var sigy_derivative = 0.0
            var x_derivative = 0.0
            var y_derivative = 0.0
            var A_derivative = 0.0
            var B_derivative = 0.0

            //numerical derivation for each of the 7 variables in the tilted gaussian profile.
               I_derivative = (SumArray[2][1][1][1][1][1][1] - SumArray[0][1][1][1][1][1][1]) / h
            sigx_derivative = (SumArray[1][2][1][1][1][1][1] - SumArray[1][0][1][1][1][1][1]) / k
               x_derivative = (SumArray[1][1][2][1][1][1][1] - SumArray[1][1][0][1][1][1][1]) / f
            sigy_derivative = (SumArray[1][1][1][2][1][1][1] - SumArray[1][1][1][0][1][1][1]) / l
               y_derivative = (SumArray[1][1][1][1][2][1][1] - SumArray[1][1][1][1][0][1][1]) / m
               A_derivative = (SumArray[1][1][1][1][1][2][1] - SumArray[1][1][1][1][1][0][1]) / n
               B_derivative = (SumArray[1][1][1][1][1][1][2] - SumArray[1][1][1][1][1][1][0]) / o
            //if they are both negative, increase them. if they are both positive, decrease them.
            
            //could do a for loop for this if they were stored in an array, but don't have time to do that. 
            if I_derivative > 0 {
                Intensity = Intensity - h
            }
            if I_derivative < 0 {
                Intensity = Intensity + h
            }
            if sigx_derivative > 0{
                Sigmax = Sigmax - k
            }
            if sigx_derivative < 0{
                Sigmax = Sigmax + k
            }
            if sigy_derivative > 0{
                Sigmay = Sigmay - l
            }
            if sigy_derivative < 0{
                Sigmay = Sigmax + l
            }
            if x_derivative > 0{
                x_0 = x_0 - f
            }
            if x_derivative < 0{
                x_0 = x_0 + f
            }
            if y_derivative > 0{
                y_0 = y_0 - m
            }
            if y_derivative < 0{
                y_0 = y_0 + m
            }
            if A_derivative > 0{
                A = A - n
            }
            if A_derivative < 0{
                A = A + n
            }
            if B_derivative > 0{
                B = B - o
            }
            if B_derivative < 0{
                B = B + o
            }

        }

    }
}
