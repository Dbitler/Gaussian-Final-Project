//
//  ContentView.swift
//  2D Gaussian Test
//
//  Created by IIT PHYS 440 on 4/13/23.
//
// Main problems left to solve:
// ----------------------------
// need to make the graphs update when variables are edited and the button is pressed.
// call to testingGaussian is unused?? what????
// the baseline graph function refuses to graph, despite the function clearly being called upon????
// graph changes to ellipsoidal when the string is changed in the code, but not when it is changed in the text box. 
// That's it, i guess????

import SwiftUI

struct ContentView: View {
    @ObservedObject var mygaussianinstance = GaussianFinder()
    @ObservedObject var myequationinstance = BaselineGaussianEquations()
    @State var gaussFinder = TestGaussianFinder()
    @State var Istring = ""
    @State var Sxstring = ""
    @State var Systring = ""
    @State var Astring = ""
    @State var Bstring = ""
    @State var xstring = ""
    @State var ystring = ""
    @State var numstring = ""
    
    let Width = 15
    let Height = 15
    var body: some View {
        VStack{
            HStack{
                VStack{
                    TextField("Starting intensity value", text: $mygaussianinstance.Iteststring)
                    
                    TextField("Starting sigma_x^2 value", text: $mygaussianinstance.Sxteststring)
                    
                    TextField("Starting sigma_y^2 value", text: $mygaussianinstance.Syteststring)
                 
                    TextField("Starting central x value", text: $mygaussianinstance.xteststring)
               
                    TextField("Starting central y value", text: $mygaussianinstance.yteststring)
                
                    TextField("Starting A value", text: $mygaussianinstance.Ateststring)
                   
                    TextField("Starting B value", text: $mygaussianinstance.Bteststring)

                }
                .padding()
                VStack{
                    TextField("True intensity value", text: $mygaussianinstance.Itruestring)
                    
                    TextField("True sigma_x^2 value", text: $mygaussianinstance.Sxtruestring)
                    
                    TextField("True sigma_y^2 value", text: $mygaussianinstance.Sytruestring)
                 
                    TextField("True x value", text: $mygaussianinstance.xtruestring)
               
                    TextField("True y value", text: $mygaussianinstance.ytruestring)
                
                    TextField("True A Value", text: $mygaussianinstance.Atruestring)
                   
                    TextField("True B Value", text: $mygaussianinstance.Btruestring)
                    
                }
                .padding()
            }
            HStack{
                VStack{
                    Text(mygaussianinstance.Istring)
    
                    Text(mygaussianinstance.Sxstring)
                   
                    Text(mygaussianinstance.Astring)
                  
                    Text(mygaussianinstance.xstring)
                    
                }
                VStack{
                    Text(mygaussianinstance.numstring)
                
                    Text(mygaussianinstance.Systring)
                   
                    Text(mygaussianinstance.Bstring)
                   
                    Text(mygaussianinstance.ystring)
                 
                }
            }
            HStack{
                Canvas{ context, size in gaussFinder.BaselineTestGaussian()
                    for value in gaussFinder.intensities{
                        let rect = CGRect(x: value.x * (size.width/CGFloat(Width)), y: value.y * (size.height/CGFloat(Height)), width: (size.height/CGFloat(Width)), height: (size.height/CGFloat(Height)))
                        let shape = Rectangle().path(in: rect)
                        context.fill(shape, with: .color(Color(red: 0.0 + value.intensity, green: 0.3 - value.intensity, blue: 0.5 - value.intensity)))

                    }

                }
                .frame(width: 200, height: 200)
                // above code squashes and stretches graph, adds black lines. FIXED. needed to add the frame code. Need to make it so it doesn't graph until you hit the button.

                .background(.black)
                .ignoresSafeArea()
                .padding()
                Canvas{ context, size in gaussFinder.FittingGaussian()
                    for value in gaussFinder.fittingintensities{
                        let rect = CGRect(x: value.x * (size.width/CGFloat(Width)), y: value.y * (size.height/CGFloat(Width)), width: (size.height/CGFloat(Width)), height: (size.height/CGFloat(Width)))
                        let shape = Rectangle().path(in: rect)
                        context.fill(shape, with: .color(Color(red: 0.0 + value.intensity, green: 0.3 - value.intensity, blue: 0.5 - value.intensity)))
                        
                    }
                    
                }
                .frame(width: 200, height: 200)
                .background(.black)
                .ignoresSafeArea()
                .padding()
            }
                    
                
            }
            .padding()
            VStack{
                Button("Click for Least Squares", action: {TestingFunction()
                    gaussFinder.Test = true
                    
                    
                })
                Button("Click for Graph", action: {GraphTest()
                    gaussFinder.Baseline = true
                })
            }
                    
        }


    //the least square is the one that needs to be given, and show the calculated values as close as possible. numerically differentiate the equation to get the gradient, to show how close it is to the possible minimum. Can only get close, not exactly 0, because of the noise in the IPRO data.
    
    func TestingFunction(){
        mygaussianinstance.TestingGaussian()
    }
    func GraphTest(){
        gaussFinder.BaselineTestGaussian()
    }
//    func setupSpins(){
//
//        gaussFinder.BaselineTestGaussian(Width: Int(Width), Height: Int(Height))
//
//    }
}
struct Intensity: Hashable, Equatable {
    var x: Double
    var y: Double
    var intensity: Double
    
}

class TestGaussianFinder: ObservableObject{
    //var intensities: [Intensity] = []
    var intensities: [(x:Double, y:Double, intensity:Double)] = []
    var fittingintensities: [(x:Double, y:Double, intensity:Double)] = []
    var mygaussianinstance = GaussianFinder()
    var myequationinstance = BaselineGaussianEquations()
    
    var Test = false
    var Baseline = false
  
   

    func BaselineTestGaussian(){
        intensities = []
        //This only comes on if i press Graph then do least squares??? waht the fuck??????????
        //if Baseline == true {
            print("hello")
            let I_0 = Double(mygaussianinstance.Itruestring)!
            let width = 15
            let height = 15
            //let Intensity = 1.5
            let sigma_x = Double(mygaussianinstance.Sxtruestring)!
            let sigma_y = Double(mygaussianinstance.Sytruestring)!
            let x_0 = Double(mygaussianinstance.xtruestring)!
            let y_0 = Double(mygaussianinstance.ytruestring)!
            let A = Double(mygaussianinstance.Ateststring)!
            let B = Double(mygaussianinstance.Bteststring)!
            var normalizefactor = 0.0
            var positivefactor = 0.0
            for x in 0..<width{
                for y in 0..<height{
                    let value = myequationinstance.Gaussianeqn(x: x, y: y, x_0: x_0, y_0: y_0, sigma_x: sigma_x, sigma_y: sigma_y, I_0: 5.0, A: A, B: B)
                    // intensities.append(Intensity(x: Double(x), y: Double(y), intensity: Double(value)))
                    if value > normalizefactor{
                        normalizefactor = value
                    }
                    if value < positivefactor{
                        positivefactor = value
                    }
                    intensities.append((x: Double(x), y: Double(y), intensity: Double(value)))
                    //intensities.append(Intensity(x: Double(x), y: Double(y), intensity: Double(value)))
                    //have to normalize the values, such that the maximum value in the graph is =1, so that the colors of the graph look alright.
                }
            }
            // this normalizes the data, such that the data is all positive and between 0 and 1, thus preventing the color code from peaking out and flattening the curve. has the side effect of making every graph look the same.
            for y in 0..<(height*width){
                intensities[y].2 = Double(intensities[y].intensity) - positivefactor
                intensities[y].2 = Double(intensities[y].intensity) / normalizefactor
            }
            
            //print(intensities)
        
    }
    
    func FittingGaussian(){
        fittingintensities = []
        if Test == true {
            let width = 15
            let height = 15
            var normalizefactor_fit = 0.0
            var positivefactor_fit = 0.0
            let foundParameters :[Double] = mygaussianinstance.TestingGaussian()
            for x in 0..<width{
                for y in 0..<height{
                    let value = myequationinstance.Gaussianeqn(x: x, y: y, x_0: foundParameters[5], y_0: foundParameters[6], sigma_x: foundParameters[1], sigma_y: foundParameters[2], I_0: foundParameters[0], A: foundParameters[3], B: foundParameters[4])
                    if value > normalizefactor_fit{
                        normalizefactor_fit = value
                    }
                    if value < positivefactor_fit{
                        positivefactor_fit = value
                    }
                    //intensities.append(Intensity(x: Double(x), y: Double(y), intensity: Double(value))
                    fittingintensities.append((x: Double(x), y: Double(y), intensity: Double(value)))
                    //need to make this return to the GaussFinder, so that i can be displayed in the graph proper.
                }
            }
            for y in 0..<(height*width){
                fittingintensities[y].2 = Double(fittingintensities[y].intensity) - positivefactor_fit
                fittingintensities[y].2 = Double(fittingintensities[y].intensity) / normalizefactor_fit
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
