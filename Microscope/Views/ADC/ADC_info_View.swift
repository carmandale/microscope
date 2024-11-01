import SwiftUI

struct ADC_info_View: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title Section
            VStack(alignment: .leading, spacing: 4) {
                Text("ADC")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Text("(Antibody-Drug Conjugates)")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            // Divider line
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.blue)
                .padding(.vertical, 8)
            
            // Description
            Text("Antibody-drug conjugates (ADCs) are targeted cancer therapies that combine the specific targeting capabilities of monoclonal antibodies with the cell-killing properties of cytotoxic drugs. The antibody part binds to specific antigens on cancer cells, allowing the attached drug to be directly delivered to the cancer cells, minimizing damage to healthy tissues. ADCs represent a powerful tool in oncology, offering enhanced precision in treatment with fewer side effects compared to traditional chemotherapy.")
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(4)
            
            Spacer()
        }
        .padding(24)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        }
        .frame(width: 500)
    }
}

#Preview {
    ADC_info_View()
} 