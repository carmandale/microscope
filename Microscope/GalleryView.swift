import SwiftUI
import QuickLook
import RealityKit
import RealityKitContent

struct GalleryItem: Identifiable {
    let id = UUID()
    let filename: String
    var thumbnailImage: UIImage?
}

struct GalleryView: View {
    @Environment(AppModel.self) private var appModel
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    @State private var galleryItems: [GalleryItem] = []
    @State private var selectedItem: GalleryItem?
    @State private var viewMode: ViewMode = .gallery
    
    enum ViewMode: String, CaseIterable {
        case gallery = "Spatial Image Gallery"
        case adc = "Build an ADC"
        case lab = "Lab View"
    }
    
    let columns = [GridItem(.adaptive(minimum: 300), spacing: 20)]
    
    private func loadGalleryItems() {
        if let resourcePath = Bundle.main.resourcePath {
            do {
                let contents = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                let heicFiles = contents.filter { $0.hasSuffix(".heic") }.sorted()
                galleryItems = heicFiles.map { filename in
                    let path = Bundle.main.path(forResource: filename.replacingOccurrences(of: ".heic", with: ""), ofType: "heic")
                    let thumbnail = path.flatMap { UIImage(contentsOfFile: $0) }
                    return GalleryItem(filename: filename, thumbnailImage: thumbnail)
                }
            } catch {
                print("Error loading gallery items: \(error)")
            }
        }
    }
    
    private func handleSpaceTransition(for mode: ViewMode) {
        Task {
            // First dismiss any open space
            if appModel.immersiveSpaceState == .open {
                await dismissImmersiveSpace()
                appModel.immersiveSpaceState = .closed
            }
            
            // Then open the new space if we're not going back to gallery
            if mode != .gallery {
                appModel.immersiveSpaceState = .inTransition
                let spaceId = mode == .adc ? appModel.adcSpaceID : appModel.labSpaceID
                let result = await openImmersiveSpace(id: spaceId)
                if case .error = result {
                    viewMode = .gallery
                    appModel.immersiveSpaceState = .closed
                }
            }
        }
    }
    
    var galleryContent: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(galleryItems) { item in
                    if let thumbnailImage = item.thumbnailImage {
                        Image(uiImage: thumbnailImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedItem?.id == item.id ? Color.blue : Color.clear, lineWidth: 3)
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedItem = item
                                if let spatialURL = Bundle.main.url(forResource: item.filename.replacingOccurrences(of: ".heic", with: ""), withExtension: "heic") {
                                    let previewItem = PreviewItem(url: spatialURL)
                                    _ = PreviewApplication.open(items: [previewItem])
                                }
                            }
                            .hoverEffect(.highlight)
                    }
                }
            }
            .padding()
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewMode {
                case .gallery:
                    galleryContent
                case .adc:
                    ADC_2D_View()
                case .lab:
                    LAB_2D_View()
                }
            }
            .safeAreaInset(edge: .bottom) {
                Picker("View Mode", selection: $viewMode) {
                    ForEach(ViewMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue)
                            .tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                .background(.ultraThinMaterial)
            }
        }
        .onAppear {
            loadGalleryItems()
        }
        .onChange(of: viewMode) { oldMode, newMode in
            handleSpaceTransition(for: newMode)
        }
    }
}

#Preview {
    GalleryView()
        .environment(AppModel())
}
