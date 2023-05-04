//
//  GaussianFinder.swift
//  Gaussian Final Project
//
//  Created by IIT PHYS 440 on 4/28/23.
//

import SwiftUI

class GaussianFinder: ObservableObject {
    @ObservedObject var mysuminstance = SumFinder()
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

//    let I_0 = 1.5
//    let width = 15
//    let height = 15
//    var numloop = 0.0
//    var sum = 0.0
//    var Intensity = 1.5
//    var Sigmax = 1.3
//    var Sigmay = 1.3
//    var x_0 = 7.0
//    var y_0 = 7.0
//    var A = 0.006
//    var B = 0.006

    // used by the testing function
    func TiltedGaussian(I_0: Double, A: Double, B: Double, x_0: Double, y_0: Double, sigma_x: Double, sigma_y: Double, width: Int, height: Int) -> [[Double]]{
        var valuesarray: [(X:Double, Y:Double, Intensity:Double)] = []
        var numbers = [[Double]](repeating: [Double](repeating: 0.0, count: 15), count: 15)
        ////15x15 matrix, each would have the
        //print(numbers2)
        for x in 0..<width{
            for y in 0..<height{
                let intensity = Gaussianeqn(x: x, y: y, x_0: x_0, y_0: y_0, sigma_x: sigma_x, sigma_y: sigma_y, I_0: I_0, A: A, B: B)
                valuesarray.append((X: Double(x), Y: Double(y), Intensity: intensity))
                numbers[x][y]=intensity
            }
        }
        return(numbers)
    }
//    func TiltedGaussian2(I_0: Double, A: Double, B: Double, x_0: Double, y_0: Double, sigma_x: Double, sigma_y: Double, width: Int, height: Int) -> [(X:Double, Y:Double, Intensity:Double)]{
//        var valuesarray: [(X:Double, Y:Double, Intensity:Double)] = []
//    for x in 0..<width{
//            for y in 0..<height{
//                let intensity = Gaussianeqn(x: x, y: y, x_0: x_0, y_0: y_0, sigma_x: sigma_x, sigma_y: sigma_y, I_0: I_0, A: A, B: B)
//                valuesarray.append((X: Double(x), Y: Double(y), Intensity: intensity))
//            }
//        }
//        return(valuesarray)
//    }
    //this function is the loop that the base TiltedGaussian Functiona and the TestingGaussian utilize, which essentially finds the value of a gaussian function, using the given parameters, at a given x-y coordinate.
    func Gaussianeqn(x: Int, y: Int, x_0: Double, y_0: Double, sigma_x: Double, sigma_y: Double, I_0: Double, A: Double, B: Double) -> Double{
        let term1 = pow((Double(x)-x_0),2.0)/pow(sigma_x,2.0)
        let term2 = pow((Double(y)-y_0),2.0)/pow(sigma_y,2.0)
        //let exponential = I_0 * exp(-(term1 + term2))
        let exponential = I_0 * exp(-(term1 + term2))
        let value = exponential + (A * (Double(x)-x_0)) + (B * (Double(y)-y_0))
        return(value)
    }
    
    func TestingGaussian() -> [Double]{
        let I_true = Double(Itruestring)!
        var Intensity = Double(Iteststring)!
        
        
        let I_0 = 1.5
        let width = 15
        let height = 15
        var numloop = 0.0
       // var Intensity = 1.5
        var Sigmax = Double(Sxteststring)!
        var Sigmay = Double(Syteststring)!
        let sigx_true = Double(Sxtruestring)!
        let sigy_true = Double(Sytruestring)!
        
        
        var x_0 = 7.0
        var y_0 = 7.0
        var A = 0.006
        var B = 0.006
        //tolerances are very low, it can't handle too big of a spread, or else it finds a false minimum to fall into.
        //things still to do: optimize the code more, seperate it into instances.
        var I_test = Intensity
        var Sigx_test = Sigmax
        var Sigy_test = Sigmay
        var x0_test = x_0
        var y0_test = y_0
        var A_test = A
        var B_test = B

        var minimized = true
        let TestingValues = TiltedGaussian(I_0: I_true, A: 0.006, B: 0.006, x_0: 7.0, y_0: 7.0, sigma_x: 1.3, sigma_y: 1.3, width: 15, height: 15)
        //this is the Intensity that the function below is testing against, to find the least squares. In the IPRO code, this would be removed,and it would be instead testing against the raw data.
        while minimized{
            //3x3x3x3x3x3x3 matrix
           var SumArray = Array(repeating: Array(repeating: Array(repeating: Array(repeating: Array(repeating: Array(repeating: Array(repeating: 0.0, count: 3), count: 3), count: 3), count: 3), count: 3), count: 3), count: 3)
            var TestedValues = [[Double]](repeating: [Double](repeating: 0.0, count: 15), count: 15)
            let h = 0.01
            let k = 0.01
            let f = 0.01
            let l = 0.01
            let m = 0.01
            let n = 0.0001
            let o = 0.0001
            var sum = 0.0
           //let SumArray = mysuminstance.Sumfinder(Intensity: Intensity, A: A, B: A, x_0: x_0, y_0: y_0, Sigmax: Sigmax, Sigmay: Sigmay, width: width, height: height, h: h, k: k, f: f, l: l, m: m, n: n, o: o, TestingValues: TestingValues)
            //Need to get this to work.
            for I in 0...2{
                for J in 0...2{
                    for K in 0...2{
                        for L in 0...2{
                            for M in 0...2{
                                for N in 0...2{
                                    for O in 0...2{
                                        sum = 0.0
                                        I_test = Intensity
                                        Sigx_test = Sigmax
                                        Sigy_test = Sigmay
                                        x0_test = x_0
                                        y0_test = y_0
                                        A_test = A
                                        B_test = B

//                                        Sigx_test = Sigmax + (Double(J - 1) * k * Sigmax)
//                                        Sigy_test = Sigmay + (Double(L - 1) * l * Sigmay)
//                                        I_test  = Intensity + (Double(I - 1) * h * Intensity)
//                                        x0_test = x_0 + (Double(K - 1) * f * x_0)
//                                        y0_test = y_0 + (Double(M - 1) * m * x_0)
//                                        A_test = A + (Double(N - 1) * n * A)
//                                        B_test = B + (Double(O - 1) * o * B)

                                        Sigx_test = Sigmax + (Double(J - 1) * k)
                                        Sigy_test = Sigmay + (Double(L - 1) * l)
                                        I_test  = Intensity + (Double(I - 1) * h)
                                        x0_test = x_0 + (Double(K - 1) * f)
                                        y0_test = y_0 + (Double(M - 1) * m)
                                        A_test = A + (Double(N - 1) * n )
                                        B_test = B + (Double(O - 1) * o )

//no idea how this program would react to trying to creat a gaussian profile near the edge of a photo, because you would have to only fit half a gaussian. should probably discard star candidates within 7-8 pixels of the edge.
                                        for x in 0..<width{
                                            for y in 0..<height{
                                                let intensity = Gaussianeqn(x: x, y: y, x_0: x0_test, y_0: y0_test, sigma_x: Sigx_test, sigma_y: Sigy_test, I_0: I_test, A: A_test, B: B_test)
                                                //this is the array that will become graphed.
                                                TestedValues[x][y]=intensity
                                                sum = sum + pow((TestingValues[x][y] - TestedValues[x][y]),2)
                                            }
                                        }
                                        // print(I_test,Sig_test, sum)
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
            if SumArray[1][1][1][1][1][1][1] <= 0.005{
                minimized = false
                 foundParameters = []
//                print("the value of I is \(Intensity)")
//                print("the value of sigma_x^2 is \(Sigmax)")
//                print("the value of sigma_y^2 is \(Sigmay)")
//                print("the value of x_0 is \(x_0)")
//                print("the value of y_0 is \(x_0)")
//                print("the value of A is \(A)")
//                print("the value of B is \(B)")
//                print("there were \(numloop) loops!")
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
//                for x in 0..<width{
//                    for y in 0..<height{
//                        let intensity = Gaussianeqn(x: x, y: y, x_0: x0_test, y_0: y0_test, sigma_x: Sigx_test, sigma_y: Sigy_test, I_0: I_test, A: A_test, B: B_test)
//                        intensities.append((x: Double(x), y: Double(y), intensity: Double(intensity)))
//                        //need to make this return to the GaussFinder, so that i can be displayed in the graph proper.
//                    }
//                }
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
