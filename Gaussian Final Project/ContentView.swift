//
//  ContentView.swift
//  2D Gaussian Test
//
//  Created by IIT PHYS 440 on 4/13/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var Istring = ""
    @State var Sxstring = ""
    @State var Systring = ""
    @State var Astring = ""
    @State var Bstring = ""
    @State var xstring = ""
    @State var ystring = ""
    @State var numstring = ""
    
    let Width = 15.0
    //want the color to vary with intensity, with red being at the peak and blue being at the nadir.
    @State var GColor = Color(red: 0.25, green: 0.5, blue: 0.75)
    var body: some View {
        VStack{
            HStack{
                VStack{
                    Text(Istring)
                        .padding()
                    Text(Sxstring)
                        .padding()
                    Text(Astring)
                        .padding()
                    Text(xstring)
                        .padding()
                }
                VStack{
                    Text(numstring)
                        .padding()
                    Text(Systring)
                        .padding()
                    Text(Bstring)
                        .padding()
                    Text(ystring)
                        .padding()
                }
            }
            .padding()
            VStack{
                Button("Click for Least Squares", action: TestSet2)
            }
            
            //            VStack{
            //                Canvas{ context, size in GaussianFinder()
            //                    for value in GaussianFinder().values{
            //                        let rect = CGRect(x: value.x * (size.width/CGFloat(Width)), y: value.y * (size.height/CGFloat(Width)), width: (size.height/CGFloat(Width)), height: (size.height/CGFloat(Width)))
            //                        let shape = Rectangle().path(in: rect)
            //                        context.fill(shape, with: .color($GColor))
            //                    }
            //                }
            //            }
        }
    }
    
        func GaussianFinderforLeastSquares() -> [[Double]]{
    
            //need to be able to take this function, and iterate it several times, taking the peak intensity and formatting a gaussian profile around it. I also need to be able to sort through over 6000 different star candidates, somehow differentiating and disposing of the duds. I don't know what the duds would look like.
    
            let x_0 = 7.0
            let y_0 = 7.0
            let sigma_x = 1.3
            let sigma_y = 1.3
    
            //for A and B, they basically indicate how "tilted" the function is, what kind of plane it is on
            //Only things I have to find in the fitting are A, B and the two variances.
            let A = 0.005
            let B = 0.008
            //in this case, I_0 is valueCenter in the IPRO function, as it is the peak intensity.
            let I_0 = 1.0
            let width = 15
            let height = 15
    
            let values = TiltedGaussian(I_0: I_0, A: A, B: B, x_0: x_0, y_0: y_0, sigma_x: sigma_x, sigma_y: sigma_y, width: width, height: height)
            return values
        }
    
    func TiltedGaussian(I_0: Double, A: Double, B: Double, x_0: Double, y_0: Double, sigma_x: Double, sigma_y: Double, width: Int, height: Int) -> [[Double]]{
        var valuesarray: [(X:Double, Y:Double, Intensity:Double)] = []
        
        
        var numbers = [[Double]](repeating: [Double](repeating: 0.0, count: 15), count: 15)
        ////15x15 matrix, each would have the
        //print(numbers2)
        
        
        
        for x in 0..<width{
            for y in 0..<height{
                
                let term1 = pow((Double(x)-x_0),2.0)/pow(sigma_x,2.0)
                let term2 = pow((Double(y)-y_0),2.0)/pow(sigma_y,2.0)
                //let exponential = I_0 * exp(-(term1 + term2))
                let exponential = I_0 * exp(-(term1 + term2))
                let intensity = exponential + (A * (Double(x)-x_0)) + (B * (Double(y)-y_0))
                
                valuesarray.append((X: Double(x), Y: Double(y), Intensity: intensity))
                numbers[x][y]=intensity
            }
            
        }
        return(numbers)
        
        
    }
    //the least square is the one that needs to be given, and show the calculated values as close as possible. numerically differentiate the equation to get the gradient, to show how close it is to the possible minimum. Can only get close, not exactly 0, because of the noise in the IPRO data.

    func TestSet2() {
        
        let I_0 = 0.9
        let width = 15
        let height = 15
        var numloop = 0.0
        
        //    let A = 0.006
        //    let B = 0.003
        //let sigma_x = 1.1
        //let sigma_y = 1.1
        //these are ALL GUESSES. NEED TO FIND THE TRUE VALUES FOR A B X Y SIGMAS AND I_0
        
        let values = GaussianFinderforLeastSquares()

        var numbers = values
        var numbers2 = [[Double]](repeating: [Double](repeating: 0.0, count: 15), count: 15)
        var sum = 0.0
 //simplify it down to a 1 d gaussian, only for X. remove the A, B, and Y, so you only have to calculate I = I_0 e^-(x/sigma)^2
        
        //simplified, so I= intensity_0 and sigma_x = s. need to do a while loop, maybe? to get the gradient descent? g= gradient.
        sum = 0.0

        //tolerances are very low, it can't handle too big of a spread, or else it finds a false minimum to fall into.
        
        //things still to do: optimize the code more, seperate it into instances, make the graphing code animated rectangles work, comment the code. Make the rectangles
        var Intensity = 1.4
        var Sigmax = 1.4
        var Sigmay = 1.1
        var x_0 = 6.9
        var y_0 = 7.2
        var A = 0.005
        var B = 0.007
        
        var I_test = Intensity
        var Sigx_test = Sigmax
        var Sigy_test = Sigmay
        var x0_test = x_0
        var y0_test = y_0
        var A_test = A
        var B_test = B
        
        var minimized = true
        let TestingValues = TiltedGaussian(I_0: 1.5, A: 0.006, B: 0.006, x_0: 7.0, y_0: 7.0, sigma_x: 1.3, sigma_y: 1.3, width: 15, height: 15)
        //this is the Intensity that the function below is testing against, to find the least squares. In the IPRO code, this would be removed,and it would be instead testing against the raw data.
        while minimized{
          //  var TestArray = Array(repeating: Array(repeating: 0.0, count: 3), count: 3)
            //3x3x3x3x3x3x3 matrix
            var SumArray = Array(repeating: Array(repeating: Array(repeating: Array(repeating: Array(repeating: Array(repeating: Array(repeating: 0.0, count: 3), count: 3), count: 3), count: 3), count: 3), count: 3), count: 3)
            let h = 0.01
            let k = 0.01
            let f = 0.01
            let l = 0.01
            let m = 0.01
            let n = 0.0001
            let o = 0.0001
            
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
                                        
                                        
                                        for x in 0..<width{
                                            for y in 0..<height{
                                                let term1 = pow((Double(x)-x0_test),2.0)/pow(Sigx_test,2.0)
                                                let term2 = pow((Double(y)-y0_test),2.0)/pow(Sigy_test,2.0)
                                                let exponential = I_test * exp(-(term1+term2))
                                                let intensity = exponential + (A_test * (Double(x)-x0_test)) + (B_test * (Double(y)-y0_test))
                                                numbers2[x][y]=intensity
                                                sum = sum + pow((TestingValues[x][y] - numbers2[x][y]),2)
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
            print(Intensity, Sigmax, x_0, y_0, Sigmay, A, B)
            if SumArray[1][1][1][1][1][1][1] <= 0.005{
                minimized = false
//                print("the value of I is \(Intensity)")
//                print("the value of sigma_x^2 is \(Sigmax)")
//                print("the value of sigma_y^2 is \(Sigmay)")
//
//                print("the value of x_0 is \(x_0)")
//                print("the value of y_0 is \(x_0)")
//
//                print("the value of A is \(A)")
//                print("the value of B is \(B)")
                print("there were \(numloop) loops!")
                self.Istring = "The value of I is \(Intensity)."
                Istring = String(format: "The value of the central intensity is %.2f.", Intensity)
//                self.Sxstring = "The value of sigma_x^2 is \(round(Sigmax))."
                Sxstring = String(format: "The value of sigma_x^2 is %.1f.", Sigmax)
//                self.Systring = "The value of sigma_y^2 is \(Sigmay)."
                Systring = String(format: "The value of sigma_y^2 is %.1f.", Sigmay)
                //self.Astring = "The value of A is \(A)."
                Astring = String(format: "The value of A is %.3f.", A)
                Bstring = String(format: "The value of B is %.3f.", B)
                xstring = String(format: "The value of x is %.2f.", x_0)
                ystring = String(format: "The value of y is %.2f.", y_0)
                self.numstring = "There were \(numloop) loops to get here!"
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
