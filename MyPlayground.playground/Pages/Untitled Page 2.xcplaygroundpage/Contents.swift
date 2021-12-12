import SwiftUI
import Combine
import PlaygroundSupport
import Foundation

enum WaveType: String, CaseIterable {
    case SIN
    case TRI
    case SQUARE
    case SAW
    case NOISE
    
    var waveForm: (Double) -> Double {
        switch self {
        case .SIN:
            return sin
        case .TRI:
            return triangleWave
        case .NOISE:
            return noise
        case .SQUARE:
            return squareWave
        case .SAW:
            return sawWave
        }
    }
}

func triangleWave(_ input: Double) -> Double {
    return abs((input + Double.pi/2).remainder(dividingBy:Double.pi*2)/Double.pi)-0.5
}

func squareWave(_ input: Double) -> Double  {
    return (input.remainder(dividingBy: Double.pi*2) >= 0) ? 1 : -1
}

func sawWave(_ input: Double) -> Double {
    return input.remainder(dividingBy: Double.pi*2)/(Double.pi*2)
}

func noise(_ input: Double) -> Double {
    return Double.random(in: -1...1)
}

func combo(_ input: Double) -> Double {
    return sin(input) + noise(input)/3
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

struct WaveController: View {
    @Binding var wav: (Double) -> Double
    @State var frequency = 1.0
    @State var magnitude = 0.25
    @State var phase = 0.0
    @State var waveType = WaveType.SIN
    var body: some View {
        VStack {
            Picker(selection: $waveType, label: Text("")) {
                ForEach(WaveType.allCases, id: \.rawValue){ waveType in
                    Text("\(waveType.rawValue)").tag(waveType)
                }
            }.pickerStyle(SegmentedPickerStyle()).frame(height: 100).padding()
            Text("\(frequency)")
            Slider(value: $frequency, in: 0.0...5.0).onChange(of: frequency) { _ in
                setWave()
            }
            
            Text("\(magnitude)")
            Slider(value: $magnitude, in: 0.0...2.0).onChange(of: magnitude) { _ in
                setWave()
            }
            
            Text("\(phase)")
            Slider(value: $phase, in: (Double.pi*(-2))...Double.pi*(2)).onChange(of: phase) { _ in
                setWave()
            }
        }.onChange(of: waveType) { _ in
            setWave()
        }
    }
    
    func setWave() {
        wav = { waveType.waveForm($0*frequency + phase)*magnitude}
    }
}

struct ContentView: View {
    @State var wav1: (Double) -> Double = sin
    @State var wav2: (Double) -> Double = sin
    @State var wav3: (Double) -> Double = sin
    @State var wav4: (Double) -> Double = sin
    var body: some View {
        VStack {
            HStack {
                WaveController(wav: $wav1)
                WaveController(wav: $wav2)
            }
            HStack {
                WaveController(wav: $wav3)
                WaveController(wav: $wav4)
            }
            
//            WaveBowView()
            WaveBowView(wav: { wav1($0) + wav2($0) + wav3($0) + wav4($0)})
//            WaveBowView(wav: {squareWave($0)/2+squareWave($0*3.7)/4+squareWave($0*19)/20 + sin($0*9.3)/3})
//            WaveBowView(wav: {sawWave($0*2.6)})
//            WaveBowView(wav: {(sin($0) + triangleWave($0*8) )/2})
//            WaveBowView(wav: {(sin($0) + sin($0*3)/3)/2})
//            WaveBowView(wav: {(triangleWave($0) + sin($0)/3)})
//            WaveBowView(wav: {abs(sin($0) + noise($0)/4 + sawWave($0*4)/4) + sin($0)/2})
//            WaveBowView(wav: {sin($0)/2 + sawWave($0*2)/2 + noise($0)/8})
//            WaveBowView(wav: {sin($0) + sin($0*4)/4 + sin($0*8)/8})
//            WaveBowView(wav: {sin($0) + triangleWave($0*3)/6 + noise($0)/20})
//            WaveBowView(wav: {noise($0)})
        }
    }
}

struct PolarView: View {
    var wav: (Double) -> Double = sin
    let radius = 120.0
    let drawPoints = 360.0
    var body: some View {
        ZStack {
            ForEach(0..<Int(drawPoints+1)) { angle in
                let (_, _, _, color) = calcRGB(angle, total: drawPoints, wav: wav)
                
                Path { path in
                    path.move(to: CGPoint(x: 200, y: 200))
                    path.addLine(to: CGPoint(x: wav(Double(angle)/drawPoints*Double.pi*2+Double.pi/2)*radius+200, y: wav(Double(angle)/drawPoints*Double.pi*2)*radius+200))
                }.stroke(color, lineWidth: 2.0)
            }
        }.frame(width: 500, height: 500)
    }
}


struct WaveBowView: View {
    var wav: (Double) -> Double = sin
    var body: some View {
        VStack {
            ColorBandView(wav: wav)
                .padding()
            
            
            WaveView(frequency: 1.0, wav: wav)
                .frame(width: 600, height: 300)
                .padding()
            
//            PolarView(wav: wav)
        }.border(Color.black, width: 4)
    }
}

var rainbowColor: (Double) -> Color {
    return {(input: Double) -> Color in
        let (_, _, _, color) = calcRGB(Int((input+1)*40), total: 20)
        return color
    }
}

struct ColorBandView: View  {
    var wav: (Double) -> Double = sin
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<200) { index in
                    let (red, blue, green, color) = calcRGB(index, total: 200, wav: wav)
                    Rectangle()
                        .fill(color)
                        .frame(width: 20, height: 60)
                }
            }
        }.frame(width: 600, height: 100)
    }
}

struct WaveView: View {
    var title: String = ""
    let frequency: Double
    var wav: (Double) -> Double = sin
    var colorWav: (Double) -> Color = {(input: Double) -> Color in
        return input >= 0 ? Color.blue : Color.green
    }
    var body: some View {
        VStack {
            Text(title)
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
}
