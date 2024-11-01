import SwiftUI

struct LAB_2D_View: View {
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        VStack(spacing: 0) {
            LabHeaderView()
            
            LibraryView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    LAB_2D_View()
        .environment(AppModel())
} 