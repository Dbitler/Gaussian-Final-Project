//
//  SumFinder.swift
//  Gaussian Final Project
//
//  Created by IIT PHYS 440 on 4/28/23.
//

import SwiftUI

class SumFinder: ObservableObject{
    
    
//    func Sumfinder(Intensity: Double, A: Double, B: Double, x_0: Double, y_0: Double, Sigmax: Double, Sigmay: Double, width: Int, height: Int, h: Double, k: Double, f: Double, l: Double, m: Double, n: Double, o: Double, TestingValues: [[Double]]) -> (Array(repeating: Array(repeating: Array(repeating: Array(repeating: Array(repeating: Array(repeating: Array(repeating: 0.0, count: 3), count: 3), count: 3), count: 3), count: 3), count: 3), count: 3)) {
//        var TestedValues = [[Double]](repeating: [Double](repeating: 0.0, count: 15), count: 15)
//        var I_test = Intensity
//        var Sigx_test = Sigmax
//        var Sigy_test = Sigmay
//        var x0_test = x_0
//        var y0_test = y_0
//        var A_test = A
//        var B_test = B
//        var SumArray = Array(repeating: Array(repeating: Array(repeating: Array(repeating: Array(repeating: Array(repeating: Array(repeating: 0.0, count: 3), count: 3), count: 3), count: 3), count: 3), count: 3), count: 3)
//        
//        for I in 0...2{
//            for J in 0...2{
//                for K in 0...2{
//                    for L in 0...2{
//                        for M in 0...2{
//                            for N in 0...2{
//                                for O in 0...2{
//                                    var sum = 0.0
//                                    I_test = Intensity
//                                    Sigx_test = Sigmax
//                                    Sigy_test = Sigmay
//                                    x0_test = x_0
//                                    y0_test = y_0
//                                    A_test = A
//                                    B_test = B
//                                    // Sigx_test = Sigmax + (Double(J - 1) * k * Sigmax)
//                                    //  Sigy_test = Sigmay + (Double(L - 1) * l * Sigmay)
//                                    // I_test  = Intensity + (Double(I - 1) * h * Intensity)
//                                    // x0_test = x_0 + (Double(K - 1) * f * x_0)
//                                    //y0_test = y_0 + (Double(M - 1) * m * x_0)
//                                    //A_test = A + (Double(N - 1) * n * A)
//                                    // B_test = B + (Double(O - 1) * o * B)
//                                    
//                                    Sigx_test = Sigmax + (Double(J - 1) * k)
//                                    Sigy_test = Sigmay + (Double(L - 1) * l)
//                                    I_test  = Intensity + (Double(I - 1) * h)
//                                    x0_test = x_0 + (Double(K - 1) * f)
//                                    y0_test = y_0 + (Double(M - 1) * m)
//                                    A_test = A + (Double(N - 1) * n )
//                                    B_test = B + (Double(O - 1) * o )
//                                    
//                                    //no idea how this program would react to trying to creat a gaussian profile near the edge of a photo, because you would have to only fit half a gaussian. should probably discard star candidates within 7-8 pixels of the edge.
//                                    for x in 0..<width{
//                                        for y in 0..<height{
//                                            let term1 = pow((Double(x)-x0_test),2.0)/pow(Sigx_test,2.0)
//                                            let term2 = pow((Double(y)-y0_test),2.0)/pow(Sigy_test,2.0)
//                                            let exponential = I_test * exp(-(term1+term2))
//                                            let intensity = exponential + (A_test * (Double(x)-x0_test)) + (B_test * (Double(y)-y0_test))
//                                            //this is the array that will become graphed.
//                                            TestedValues[x][y]=intensity
//                                            sum = sum + pow((TestingValues[x][y] - TestedValues[x][y]),2)
//                                        }
//                                    }
//                                    // print(I_test,Sig_test, sum)
//                                    SumArray[I][J][K][L][M][N][O] = sum
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
}
