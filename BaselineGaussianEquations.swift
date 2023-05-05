//
//  BaselineGaussianEquations.swift
//  Gaussian Final Project
//
//  Created by IIT PHYS 440 on 5/4/23.
//

import SwiftUI

class BaselineGaussianEquations: ObservableObject {
    
    func TiltedGaussian(I_0: Double, A: Double, B: Double, x_0: Double, y_0: Double, sigma_x: Double, sigma_y: Double, width: Int, height: Int) -> [[Double]]{
        //var valuesarray: [(X:Double, Y:Double, Intensity:Double)] = []
        var numbers = [[Double]](repeating: [Double](repeating: 0.0, count: 15), count: 15)
        ////15x15 matrix, each would have the
        //print(numbers2)
        for x in 0..<width{
            for y in 0..<height{
                let intensity = Gaussianeqn(x: x, y: y, x_0: x_0, y_0: y_0, sigma_x: sigma_x, sigma_y: sigma_y, I_0: I_0, A: A, B: B)
               // valuesarray.append((X: Double(x), Y: Double(y), Intensity: intensity))
                numbers[x][y]=intensity
            }
        }
        return(numbers)
    }
    //this function is the loop that the base TiltedGaussian Functiona and the TestingGaussian utilize, which essentially finds the value of a gaussian function, using the given parameters, at a given x-y coordinate.
    func Gaussianeqn(x: Int, y: Int, x_0: Double, y_0: Double, sigma_x: Double, sigma_y: Double, I_0: Double, A: Double, B: Double) -> Double{
        let term1 = pow((Double(x)-x_0),2.0)/pow(sigma_x,2.0)
        let term2 = pow((Double(y)-y_0),2.0)/pow(sigma_y,2.0)
        let exponential = I_0 * exp(-term1) * exp(-term2)
        //let exponential = I_0 * exp(-(term1 + term2))
        let value = exponential + (A * (Double(x)-x_0)) + (B * (Double(y)-y_0))
        return(value)
    }

}
