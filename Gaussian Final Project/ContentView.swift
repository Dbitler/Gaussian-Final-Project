//
//  ContentView.swift
//  2D Gaussian Test
//
//  Created by IIT PHYS 440 on 4/13/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var mygaussianinstance = GaussianFinder()
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
                    Text(mygaussianinstance.Istring)
                        .padding()
                    Text(mygaussianinstance.Sxstring)
                        .padding()
                    Text(mygaussianinstance.Astring)
                        .padding()
                    Text(mygaussianinstance.xstring)
                        .padding()
                }
                VStack{
                    Text(mygaussianinstance.numstring)
                        .padding()
                    Text(mygaussianinstance.Systring)
                        .padding()
                    Text(mygaussianinstance.Bstring)
                        .padding()
                    Text(mygaussianinstance.ystring)
                        .padding()
                }
            }
            .padding()
            VStack{
                //uncomment once get graph working.
                Button("Click for Least Squares", action: TestSet2)
            }
            
            VStack{
                Canvas{ context, size in GaussianFinderforLeastSquares()
                    for value in GaussianFinderforLeastSquares{
                            let rect = CGRect(x: value.x * (size.width/CGFloat(Width)), y: value.y * (size.height/CGFloat(Width)), width: (size.height/CGFloat(Width)), height: (size.height/CGFloat(Width)))
                            let shape = Rectangle().path(in: rect)
                            context.fill(shape, with: .color($GColor))
                            //the spin array in the animated rectangles file is essentially the same as the valuesarray in the tiltedgaussian function. just need to make an interpolation function for the color. 
                    }
                }
            }
//                        VStack{
//                            Canvas{ context, size in GaussianFinderforLeastSquares()
//                                for value in GaussianFinderforLeastSquares().values{
//                                    let rect = CGRect(x: value.x * (size.width/CGFloat(Width)), y: value.y * (size.height/CGFloat(Width)), width: (size.height/CGFloat(Width)), height: (size.height/CGFloat(Width)))
//                                    let shape = Rectangle().path(in: rect)
//                                    context.fill(shape, with: .color($GColor))
//                                }
//                            }
//                        }
        }
    }
    
        func GaussianFinderforLeastSquares(){

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

            let values = mygaussianinstance.TiltedGaussian(I_0: I_0, A: A, B: B, x_0: x_0, y_0: y_0, sigma_x: sigma_x, sigma_y: sigma_y, width: width, height: height)
        }


    //the least square is the one that needs to be given, and show the calculated values as close as possible. numerically differentiate the equation to get the gradient, to show how close it is to the possible minimum. Can only get close, not exactly 0, because of the noise in the IPRO data.

    
    func TestSet2(){
        mygaussianinstance.TestSet2()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
