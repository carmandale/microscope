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
    @State private var selectedVideo: VideoItem?
    @State private var selectedDocument: DocumentItem?
    
    let tabs = ["Video", "Documents"]
    
    let videos = [
        VideoItem(title: "How Climate Change is Affecting the Spread of Lyme Disease", duration: "10 min", thumbnail: "lyme_disease", category: "Research"),
        VideoItem(title: "Pfizer's Multicultural Health Equity Collective Marks 10 Years of Progress", duration: "10 min", thumbnail: "multicultural_health", category: "Community"),
        VideoItem(title: "Paving a Promising New Pathway Toward Effective and Lasting Migraine Relief", duration: "10 min", thumbnail: "migraine", category: "Research"),
        VideoItem(title: "Pharma Peers Unite to Build DNA-Encoded Libraries", duration: "10 min", thumbnail: "dna_libraries", category: "Research"),
        VideoItem(title: "Pfizer Achieves Remarkable Advances in Antibody-Drug Conjugates to Improve Cancer Treatment", duration: "10 min", thumbnail: "ADC_advances", category: "Research"),
        VideoItem(title: "Exploring the Critical Process of Finding the Perfect Antigen Match for Targeted Cancer Therapy", duration: "10 min", thumbnail: "Antigen_matches", category: "Research")
    ]
    
    let documents = [
        DocumentItem(title: "How Climate Change is Affecting the Spread of Lyme Disease", thumbnail: "lyme_doc", category: "Research"),
        DocumentItem(title: "Pfizer's Multicultural Health Equity Collective Marks 10 Years of Progress", thumbnail: "multicultural_doc", category: "Community"),
        DocumentItem(title: "Paving a Promising New Pathway Toward Effective and Lasting Migraine Relief", thumbnail: "migraine_doc", category: "Research"),
        DocumentItem(title: "Pharma Peers Unite to Build DNA-Encoded Libraries", thumbnail: "dna_doc", category: "Research"),
        DocumentItem(title: "Pfizer Achieves Remarkable Advances in Antibody-Drug Conjugates to Improve Cancer Treatment", thumbnail: "ADC_advances", category: "Research"),
        DocumentItem(title: "Exploring the Critical Process of Finding the Perfect Antigen Match for Targeted Cancer Therapy", thumbnail: "Antigen_matches", category: "Research")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Pfizer Library")
                .font(.title)
                .padding(.horizontal)
            
            Picker("Content Type", selection: $selectedTab) {
                ForEach(tabs.indices, id: \.self) { index in
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
                    VideoCardView(video: video, isSelected: video.id == selectedVideo?.id)
                        .onTapGesture {
                            selectedVideo = video
                        }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
    
    var documentGrid: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 20),
                GridItem(.flexible(), spacing: 20),
                GridItem(.flexible(), spacing: 20)
            ], spacing: 20) {
                ForEach(documents) { document in
                    DocumentCardView(document: document, isSelected: document.id == selectedDocument?.id)
                        .onTapGesture {
                            selectedDocument = document
                        }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
}

struct VideoCardView: View {
    let video: VideoItem
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                if let image = UIImage(named: video.thumbnail) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Rectangle()
                        .fill(Color.blue.opacity(0.1))
                        .aspectRatio(16/9, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundColor(.white)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
            )
            
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
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .hoverEffect(.highlight)
    }
}

struct DocumentCardView: View {
    let document: DocumentItem
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                if let image = UIImage(named: document.thumbnail) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Rectangle()
                        .fill(Color.blue.opacity(0.1))
                        .aspectRatio(16/9, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            Image(systemName: "doc.text.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44)
                                .foregroundColor(.white)
                        )
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
            )
            
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
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .hoverEffect(.highlight)
    }
}

#Preview {
    LibraryView()
} 
