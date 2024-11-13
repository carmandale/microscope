import SwiftUI

struct ADC_2D_View: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        VStack {
            GeometryReader { geometry in
                Image("ADC_Builder_Default")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width)
                    .clipped()
            }
            
            VStack(spacing: 20) {
                // Speed Multiplier Slider
                Text("Speed Multiplier: \(settings.speedMultiplier, specifier: "%.2f")")
                Slider(value: $settings.speedMultiplier, in: 0.1...10.0, step: 0.1)
                    .padding()
                
                // Flow Speed Slider
                Text("Flow Speed: \(settings.flowSpeed, specifier: "%.2f")")
                Slider(value: $settings.flowSpeed, in: 0.1...5.0, step: 0.1)
                    .padding()
                
                // Width Slider
                Text("Stream Width: \(settings.width, specifier: "%.2f") meters")
                Slider(value: $settings.width, in: 0.5...5.0, step: 0.1)
                    .padding()

                // Depth Slider
                Text("Stream Depth: \(settings.depth, specifier: "%.2f") meters")
                Slider(value: $settings.depth, in: 1.0...10.0, step: 0.1)
                    .padding()
            }
        }
    }
}
