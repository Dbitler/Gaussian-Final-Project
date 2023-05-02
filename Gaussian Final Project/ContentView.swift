//
//  ContentView.swift
//  2D Gaussian Test
//
//  Created by IIT PHYS 440 on 4/13/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var mygaussianinstance = GaussianFinder()
    @State var GaussFinder = TestGaussianFinder()
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
   // @State var GColor = Color(red: 0.25, green: 0.5, blue: 0.75)
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
                VStack{
                   // TimelineView(.animation) { timeline in
//                        Canvas{ context, size in GaussFinder.TiltedGaussian2()
//                            for value in GaussFinder.intensities{
//                                let rect = CGRect(x: value.x * (size.width/CGFloat(Width)), y: value.y * (size.height/CGFloat(Width)), width: (size.height/CGFloat(Width)), height: (size.height/CGFloat(Width)))
//                                let shape = Rectangle().path(in: rect)
//                                // context.fill(shape, with: .color($GColor))
//                                //if value.intensity > -0.02{
//                                    context.fill(shape, with: .color(Color(red: 0.0 + value.intensity, green: 0.0, blue: 0)))
//                                //}
//
//                            }
//                        }
                    // above code warps the pixels of the graph, below code has messed up graph box.
                    
                    Canvas{ context, size in GaussFinder.TiltedGaussian2()
                        for value in GaussFinder.intensities{
                            let rect = CGRect(x: value.x * (CGFloat(Width)), y: value.y * (CGFloat(Width)), width: (CGFloat(Width)), height: (CGFloat(Width)))
                            let shape = Rectangle().path(in: rect)
                            //if value.intensity > -0.02{
                            context.fill(shape, with: .color(Color(red: 0.0 + value.intensity, green: 0.2 - value.intensity, blue: 0.5 - value.intensity)))
                            //}
                            
                        }
                    }
                    //}
                    .background(.black)
                    .ignoresSafeArea()
                    .padding()
                }
            }
            .padding()
            VStack{
                //uncomment once get graph working.
                Button("Click for Least Squares", action: TestingFunction)
                Button("Click for Graph", action: GraphTest)
            }
                    
        }
    }

    //the least square is the one that needs to be given, and show the calculated values as close as possible. numerically differentiate the equation to get the gradient, to show how close it is to the possible minimum. Can only get close, not exactly 0, because of the noise in the IPRO data.
    func TestingFunction(){
        mygaussianinstance.TestingGaussian()
    }
    func GraphTest(){
        GaussFinder.TiltedGaussian2()
    }
}
struct Intensity: Hashable, Equatable {
    var x: Double
    var y: Double
    var intensity: Double
    
}

class TestGaussianFinder: ObservableObject{
    //var intensities: [Intensity] = []
    var intensities: [(x:Double, y:Double, intensity:Double)] = []
    var mygaussianinstance = GaussianFinder()
    func TiltedGaussian2(){
        let I_0 = 5.0
        let width = 15
        let height = 15
        //let Intensity = 1.5
        let sigma_x = 2.0
        let sigma_y = 2.0
        let x_0 = 6.8
        let y_0 = 7.2
        let A = 0.005
        let B = 0.007
        var normalizefactor = 0.0
        for x in 0..<width{
                for y in 0..<height{
                    let value = mygaussianinstance.Gaussianeqn(x: x, y: y, x_0: x_0, y_0: y_0, sigma_x: sigma_x, sigma_y: sigma_y, I_0: I_0, A: A, B: B)
                    //intensities.append(Intensity(x: Double(x), y: Double(y), intensity: Double(value)))
                    if value > normalizefactor{
                        normalizefactor = value
                    }
                    intensities.append((x: Double(x), y: Double(y), intensity: Double(value)))
                    //what is "cannot call value of non-function type 'Double' "
                    //have to normalize the values, such that the maximum value in the graph is =1, so that the colors of the graph look alright.
                }
        }
//        for x in 0..<width{
//            for y in 0..<height{
//                intensities[x][y].2 = Double(intensities.intensity) / normalizefactor
//            }
//        }
        // for some reason, this doesn't work at all, but it should. for some reason intensities[x] returns only the y value, [x][y] returns an error.
        
        print(intensities)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
