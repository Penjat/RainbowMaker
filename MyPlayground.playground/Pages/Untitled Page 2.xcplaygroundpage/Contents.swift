import SwiftUI
import Combine
import PlaygroundSupport
import Foundation



func triangleWave(_ input: Double) -> Double {
    return ((input+Double.pi/2 ).remainder(dividingBy:Double.pi)/Double.pi)*2
    
}

func squareWave(_ input: Double) -> Double  {
    return (input.remainder(dividingBy: Double.pi*2) >= 0) ? 1 : -1
}

func sawWave(_ input: Double) -> Double {
    return input.remainder(dividingBy: Double.pi)/(Double.pi/2)
}

func combo(_ input: Double) -> Double {
    return (triangleWave(input*10)/10 + sin(input))/2.0
}

func calcRGB(_ index: Int, total: Double, wav: (Double)->Double = sin) -> (Double, Double, Double, Color) {
    let offset1 = Double.pi*2/3*2
    let offset2 = Double.pi*2/3
    let circ = Double.pi*2
    
    let theta = Double(index)/total*circ
    let red = (wav(theta)+1)/2
    let blue = (wav(theta + offset1)+1)/2
    let green = (wav(theta + offset2)+1)/2
    let color = Color(red: red, green: green, blue: blue, opacity: 1.0)
    
    return (red, blue, green, color)
}

PlaygroundPage.current.setLiveView(ContentView())

struct ContentView: View {
    var body: some View {
        WaveView(frequency: 1.0, wav: squareWave)
            .frame(width: 600, height: 400)
            .border(Color.black, width: 4)
            .padding()
    }
}

struct WaveView: View {
    let frequency: Double
    var wav: (Double) -> Double = sin
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<40){ index in
                let height = wav(Double(index)/40.0*Double.pi*2*frequency)*80
                VStack(spacing: 0.0) {
                    VStack {
                        Spacer()
                        Rectangle().fill(Color.blue).frame(width: 10, height: height)
                    }
                    VStack {
                        Rectangle().fill(Color.orange).frame(width: 10, height: -height)
                        Spacer()
                    }
                }
                
            }
        }
    }
}


struct TestView: View {
    let numberOfnodes = 300
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .top, spacing: 0.0) {
                ForEach(0..<numberOfnodes) { index in
                    let val = Double(index)/Double(100)*Double.pi
                    let height = (combo(val)+2)*50.0
                    let (red, blue, green, color) = calcRGB(index, total: 150, wav: sin)
                    
                    VStack {
                        VStack {
                            Spacer()
                            HStack(alignment: .bottom, spacing: 0.0) {
                                
                                Rectangle().fill(Color(red: red, green: 0.0, blue: 0.0).opacity(0.5)).frame(width: 4 , height:  100*red)
                                Rectangle().fill(Color(red: 0.0, green: 0.0, blue: blue).opacity(0.5)).frame(width: 4 , height:  100*blue)
                                Rectangle().fill(Color(red: 0.0, green: green, blue: 0.0).opacity(0.5)).frame(width: 4 , height:  100*green)
                                
                            }
                        }
                        Rectangle().fill(color).frame(width: 12 , height:  height)
                    }
                }
            }.background(Color.white)
        }.frame(width: 600)
    }
}



