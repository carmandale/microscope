import SwiftUI

struct LabHeaderView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Hope Changes Lives")
                .font(.largeTitle)
                .fontWeight(.medium)
            
            Text("We're in relentless pursuit of scientific breakthroughs and revolutionary medicines that will create a healthier world for everyone")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
        .padding()
    }
} 