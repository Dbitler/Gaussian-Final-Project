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
        //something is wrong with the algorithm for sigma x and sigma y, I don't know what. Sigma x is unable to find values smaller than initial value, and sigma y is unable to find values larger than initial value. 
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
        
        let h = 0.01
        let k = 0.01
        let f = 0.01
        let l = 0.01
        let m = 0.01
        let n = 0.0001
        let o = 0.0001
        
        let Istep = h
        let Sxstep = k
        let Systep = l
        let x0step = f
        let y0step = m
        let Astep = n
        let Bstep = o
        
        while minimized{
            //3x3x3x3x3x3x3 matrix
          // let SumArray = mysuminstance.Sumfinder(Intensity: Intensity, A: A, B: B, x_0: x_0, y_0: y_0, Sigmax: Sigmax, Sigmay: Sigmay, width: width, height: height, Istep: h, Sxstep: k, Systep: l, x0step: f, y0step: m, Astep: n, Bstep: o, TestingValues: TestingValues)
            
            var TestedValues = [[Double]](repeating: [Double](repeating: 0.0, count: 15), count: 15)
            var I_test = Intensity
            var Sigx_test = Sigmax
            var Sigy_test = Sigmay
            var x0_test = x_0
            var y0_test = y_0
            var A_test = A
            var B_test = B
            var SumArray = Array(repeating: Array(repeating: Array(repeating: Array(repeating: Array(repeating: Array(repeating: Array(repeating: 0.0, count: 3), count: 3), count: 3), count: 3), count: 3), count: 3), count: 3)

            for I in 0...2{
                for J in 0...2{
                    for K in 0...2{
                        for L in 0...2{
                            for M in 0...2{
                                for N in 0...2{
                                    for O in 0...2{
                                        var sum = 0.0
                                        I_test = Intensity
                                        Sigx_test = Sigmax
                                        Sigy_test = Sigmay
                                        x0_test = x_0
                                        y0_test = y_0
                                        A_test = A
                                        B_test = B
                                        // Sigx_test = Sigmax + (Double(J - 1) * k * Sigmax)
                                        //  Sigy_test = Sigmay + (Double(L - 1) * l * Sigmay)
                                        // I_test  = Intensity + (Double(I - 1) * h * Intensity)
                                        // x0_test = x_0 + (Double(K - 1) * f * x_0)
                                        //y0_test = y_0 + (Double(M - 1) * m * x_0)
                                        //A_test = A + (Double(N - 1) * n * A)
                                        // B_test = B + (Double(O - 1) * o * B)
                                        I_test  = Intensity + (Double(I - 1) * Istep)
                                        Sigx_test = Sigmax + (Double(J - 1) * Sxstep)
                                        Sigy_test = Sigmay + (Double(L - 1) * Systep)
                                        x0_test = x_0 + (Double(K - 1) * x0step)
                                        y0_test = y_0 + (Double(M - 1) * y0step)
                                        A_test = A + (Double(N - 1) * Astep )
                                        B_test = B + (Double(O - 1) * Bstep)

                                        //no idea how this program would react to trying to creat a gaussian profile near the edge of a photo, because you would have to only fit half a gaussian. should probably discard star candidates within 7-8 pixels of the edge.
                                        for x in 0..<width{
                                            for y in 0..<height{
                                                let term1 = pow((Double(x)-x0_test),2.0)/pow(Sigx_test,2.0)
                                                let term2 = pow((Double(y)-y0_test),2.0)/pow(Sigy_test,2.0)
                                                let exponential = I_test * exp(-(term1+term2))
                                                let intensity = exponential + (A_test * (Double(x)-x0_test)) + (B_test * (Double(y)-y0_test))
                                                //this is the array that will become graphed.
                                                TestedValues[x][y]=intensity
                                                sum = sum + pow((TestingValues[x][y] - TestedValues[x][y]),2)
                                            }
                                        }
                                        // print(I_test,Sig_test, sum)
                                        //I, sx, x0, sy, y0, a, b
                                        SumArray[I][J][K][L][M][N][O] = sum
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            
            
            
            numloop = numloop + 1
            print(Intensity, Sigmax, x_0, y_0, Sigmay, A, B) //this keeps running for some reason???
            
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
               // gaussFinder.FittingGaussian(foundParameters: foundParameters)
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
            if sigx_derivative > 0 {
                Sigmax = Sigmax - k
            }
            if sigx_derivative < 0 {
                Sigmax = Sigmax + k
            }
            
            if sigy_derivative > 0 {
                Sigmay = Sigmay - l
            }
            if sigy_derivative < 0 {
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
