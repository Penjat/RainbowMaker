import SwiftUI
import Combine
import PlaygroundSupport



PlaygroundPage.current.setLiveView(ContentView())


struct ContentView: View {
    let total = 256
    
    
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<total) { index in
                    let (red, blue, green, color) = calcRGB(index, total: Double(total))
                    HStack {
                        Text("\(red)").foregroundColor(Color( red: red, green: 0.0, blue: 0.0, opacity: 1.0))
                        Text("\(blue)").foregroundColor(Color( red: 0.0, green: 0.0, blue: blue, opacity: 1.0))
                        Text("\(green)").foregroundColor(Color( red: 0.0, green: green, blue: 0.0, opacity: 1.0))
                        Text("\(red) \(blue) \(green)").foregroundColor(color)
                    }
                    
                }
            }
        }.frame(height: 500).padding()
    }
    
    func calcRGB(_ index: Int, total: Double) -> (Double, Double, Double, Color) {
        let offset1 = Double.pi*2/3*2
        let offset2 = Double.pi*2/3
        let circ = Double.pi*2
        
        let theta = Double(index)/total*circ
        let red = (sin(theta)+1)/2
        let blue = (sin(theta + offset1)+1)/2
        let green = (sin(theta + offset2)+1)/2
        let color = Color(red: red, green: green, blue: blue, opacity: 1.0)
        
        return (red, blue, green, color)
    }
}


func triangleWave(_ input: Double) -> Double {
    return abs(input.remainder(dividingBy:Double.pi)/Double.pi)*4-1

}
