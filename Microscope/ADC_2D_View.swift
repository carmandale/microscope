import SwiftUI

struct ADC_2D_View: View {
    var body: some View {
        GeometryReader { geometry in
            Image("ADC_Builder_Default")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: geometry.size.width)
                .clipped()
        }
    }
}

#Preview {
    ADC_2D_View()
}
