import SwiftUI

struct VideoItem: Identifiable {
    let id = UUID()
    let title: String
    let duration: String
    let thumbnail: String
    let category: String
}

struct DocumentItem: Identifiable {
    let id = UUID()
    let title: String
    let thumbnail: String
    let category: String
}

struct LibraryView: View {
    @State private var selectedTab = 0
    let tabs = ["Video", "Documents"]
    
    let videos = [
        VideoItem(title: "How Climate Change is Affecting the Spread of Lyme Disease", duration: "10 min", thumbnail: "lyme_disease", category: "Research"),
        VideoItem(title: "Pfizer's Multicultural Health Equity Collective Marks 10 Years of Progress", duration: "10 min", thumbnail: "multicultural_health", category: "Community"),
        VideoItem(title: "A New Road to Migraine Relief", duration: "10 min", thumbnail: "migraine", category: "Research"),
        VideoItem(title: "Pharma Peers Unite to Build DNA-Encoded Libraries", duration: "10 min", thumbnail: "dna_libraries", category: "Research")
    ]
    
    let documents = [
        DocumentItem(title: "How Climate Change is Affecting the Spread of Lyme Disease", thumbnail: "lyme_doc", category: "Research"),
        DocumentItem(title: "Pfizer's Multicultural Health Equity Collective Marks 10 Years of Progress", thumbnail: "multicultural_doc", category: "Community"),
        DocumentItem(title: "A New Road to Migraine Relief", thumbnail: "migraine_doc", category: "Research"),
        DocumentItem(title: "Pharma Peers Unite to Build DNA-Encoded Libraries", thumbnail: "dna_doc", category: "Research")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Pfizer Library")
                .font(.title)
                .padding(.horizontal)
            
            Picker("Content Type", selection: $selectedTab) {
                ForEach(0..<tabs.count) { index in
                    Text(tabs[index]).tag(index)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            if selectedTab == 0 {
                videoGrid
            } else {
                documentGrid
            }
        }
    }
    
    var videoGrid: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 300), spacing: 20)
            ], spacing: 20) {
                ForEach(videos) { video in
                    VideoCardView(video: video)
                }
            }
            .padding()
        }
    }
    
    var documentGrid: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 300), spacing: 20)
            ], spacing: 20) {
                ForEach(documents) { document in
                    DocumentCardView(document: document)
                }
            }
            .padding()
        }
    }
}

struct VideoCardView: View {
    let video: VideoItem
    
    var body: some View {
        Button(action: {
            // Handle video playback
        }) {
            VStack(alignment: .leading) {
                ZStack {
                    // Use actual image if available, fallback to placeholder
                    if let image = UIImage(named: video.thumbnail) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.1))
                            .aspectRatio(16/9, contentMode: .fit)
                    }
                    
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(video.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(video.duration)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

struct DocumentCardView: View {
    let document: DocumentItem
    
    var body: some View {
        Button(action: {
            // Handle document opening
        }) {
            VStack(alignment: .leading) {
                ZStack {
                    // Use actual image if available, fallback to placeholder
                    if let image = UIImage(named: document.thumbnail) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.1))
                            .aspectRatio(16/9, contentMode: .fit)
                            .overlay(
                                Image(systemName: "doc.text.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 44)
                                    .foregroundColor(.white)
                            )
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(document.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(document.category)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LibraryView()
} 