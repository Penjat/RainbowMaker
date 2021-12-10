import SwiftUI
import Combine
import PlaygroundSupport
import Foundation

func triangleWave(_ input: Double) -> Double {
    return abs((input + Double.pi/2).remainder(dividingBy:Double.pi*2)/Double.pi)-0.5
}

func squareWave(_ input: Double) -> Double  {
    return (input.remainder(dividingBy: Double.pi*2) >= 0) ? 1 : -1
}

func sawWave(_ input: Double) -> Double {
    return input.remainder(dividingBy: Double.pi*2)/(Double.pi)
}

func noise(_ input: Double) -> Double {
    return Double.random(in: -1...1)
}

func combo(_ input: Double) -> Double {
    return (triangleWave(input*10)/10 + sin(input))/2.0 + noise(input)/10
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
        VStack {
            ColorBandView()
//                .frame(width: 600, height: 200)
                .border(Color.black, width: 4)
                .padding()
            
            WaveView(frequency: 1.0, wav: sin, colorWav: rainbowColor)
                .frame(width: 600, height: 200)
                .border(Color.black, width: 4)
                .padding()
            WaveView(frequency: 1.0, wav: triangleWave)
                .frame(width: 600, height: 200)
                .border(Color.black, width: 4)
                .padding()
            WaveView(frequency: 1.0, wav: sawWave)
                .frame(width: 600, height: 200)
                .border(Color.black, width: 4)
                .padding()
            WaveView(frequency: 2.0, wav: squareWave)
                .frame(width: 600, height: 200)
                .border(Color.black, width: 4)
                .padding()
            WaveView(frequency: 2.0, wav: noise)
                .frame(width: 600, height: 200)
                .border(Color.black, width: 4)
                .padding()
            WaveView(frequency: 3.0, wav: combo)
                .frame(width: 600, height: 200)
                .border(Color.black, width: 4)
                .padding()
        }
    }
}

var rainbowColor: (Double) -> Color {
    return {(input: Double) -> Color in
        let (_, _, _, color) = calcRGB(Int(input*40), total: 40)
        return color
    }
}

struct ColorBandView: View  {
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<200) { index in
                    let (red, blue, green, color) = calcRGB(index, total: 100)
                    Rectangle()
                        .fill(color)
                        .frame(width: 20, height: 60)
                }
            }
        }.frame(width: 600, height: 400)
    }
}

struct WaveView: View {
    let frequency: Double
    var wav: (Double) -> Double = sin
    var colorWav: (Double) -> Color = {(input: Double) -> Color in
        return input >= 0 ? Color.blue : Color.green
    }
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<40){ index in
                let wavOutput = wav(Double(index)/40.0*Double.pi*2*frequency)
                let height = wavOutput*80
                
                VStack(spacing: 0.0) {
                    VStack {
                        Spacer()
                        Rectangle().fill(colorWav(wavOutput)).frame(width: 10, height: height)
                    }
                    VStack {
                        Rectangle().fill(colorWav(wavOutput)).frame(width: 10, height: -height)
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
