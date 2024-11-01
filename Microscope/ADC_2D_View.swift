import SwiftUI

struct ADC_2D_View: View {
    @Environment(AppModel.self) private var appModel
    
    // States for selections
    @State private var selectedAntibody: Int = 0
    @State private var selectedLinker: Int = 0
    @State private var selectedPayload: Int = 0
    
    let antibodies = ["HER2", "EGFR", "CEA"]
    let antibodyColors = [Color.blue, Color(UIColor.systemBlue), Color.yellow]
    
    var body: some View {
        HStack(spacing: 20) {
            // Left side - Main ADC Display
            VStack {
                Text("ADC Builder")
                    .font(.largeTitle)
                    .padding(.bottom)
                
                // Large antibody display
                ZStack {
                    Circle()
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                        .frame(width: 400, height: 400)
                    
                    Image(systemName: "y.circle.fill")
                        .resizable()
                        .foregroundColor(antibodyColors[selectedAntibody])
                        .frame(width: 300, height: 300)
                }
                
                // Navigation arrows
                HStack {
                    Button(action: {}) {
                        Image(systemName: "chevron.left.circle.fill")
                            .resizable()
                            .frame(width: 44, height: 44)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "chevron.right.circle.fill")
                            .resizable()
                            .frame(width: 44, height: 44)
                    }
                }
                .padding()
                
                Button("Start") {
                    // Add start action
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .frame(maxWidth: .infinity)
            
            // Right side - Components
            VStack(alignment: .leading, spacing: 30) {
                // Antibodies section
                VStack(alignment: .leading) {
                    Text("Antibodies")
                        .font(.title2)
                    
                    HStack(spacing: 20) {
                        ForEach(0..<3) { index in
                            Button(action: { selectedAntibody = index }) {
                                VStack {
                                    Image(systemName: "y.circle.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(antibodyColors[index])
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.gray.opacity(0.2))
                                                .stroke(selectedAntibody == index ? Color.blue : Color.clear, lineWidth: 2)
                                        )
                                    
                                    Text("Targets \(antibodies[index])")
                                        .font(.caption)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                // Linkers section
                VStack(alignment: .leading) {
                    Text("Linkers")
                        .font(.title2)
                    
                    HStack(spacing: 20) {
                        ForEach(0..<3) { index in
                            Button(action: { selectedLinker = index }) {
                                VStack {
                                    Rectangle()
                                        .fill(antibodyColors[index])
                                        .frame(width: 60, height: 4)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.gray.opacity(0.2))
                                                .stroke(selectedLinker == index ? Color.blue : Color.clear, lineWidth: 2)
                                        )
                                    
                                    Text(index == 0 ? "Flexible" : index == 1 ? "Moderate" : "Stable")
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                // Payload section
                VStack(alignment: .leading) {
                    Text("Payload")
                        .font(.title2)
                    
                    HStack(spacing: 20) {
                        ForEach(0..<3) { index in
                            Button(action: { selectedPayload = index }) {
                                VStack {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(antibodyColors[index])
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.gray.opacity(0.2))
                                                .stroke(selectedPayload == index ? Color.blue : Color.clear, lineWidth: 2)
                                        )
                                    
                                    Text(index == 0 ? "Optimal" : index == 1 ? "Moderate" : "Potent")
                                        .font(.caption)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding()
            .frame(width: 400)
        }
        .padding()
    }
}

#Preview {
    ADC_2D_View()
        .environment(AppModel())
} 