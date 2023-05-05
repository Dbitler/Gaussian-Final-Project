//
//  SumFinder.swift
//  Gaussian Final Project
//
//  Created by IIT PHYS 440 on 4/28/23.
//

import SwiftUI

class SumFinder: ObservableObject{
    
    //var myequationinstance: BaselineGaussianEquations? = nil
    var myequationinstance = BaselineGaussianEquations()
    
    
    func Sumfinder(Intensity: Double, A: Double, B: Double, x_0: Double, y_0: Double, Sigmax: Double, Sigmay: Double, width: Int, height: Int, Istep: Double, Sxstep: Double,  Systep: Double, x0step: Double, y0step: Double, Astep: Double, Bstep: Double, TestingValues: [[Double]]) -> [[[[[[[Double]]]]]]] {
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
//                                     Sigx_test = Sigmax + (Double(J - 1) * Sxstep * Sigmax)
//                                      Sigy_test = Sigmay + (Double(L - 1) * Systep * Sigmay)
//                                     I_test  = Intensity + (Double(I - 1) * Istep * Intensity)
//                                     x0_test = x_0 + (Double(K - 1) * x0step * x_0)
//                                    y0_test = y_0 + (Double(M - 1) * y0step * y_0)
//                                    A_test = A + (Double(N - 1) * Astep * A)
//                                     B_test = B + (Double(O - 1) * Bstep * B)
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
                                            let intensity = myequationinstance.Gaussianeqn(x: x, y: y, x_0: x0_test, y_0: y0_test, sigma_x: Sigx_test, sigma_y: Sigy_test, I_0: I_test, A: A_test, B: B_test)
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
return SumArray
    }
}
