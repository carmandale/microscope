import SwiftUI
import RealityKitContent
import AVFoundation

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    private var audioPlayer: AVAudioPlayer?
    
    init() {
        // Remove component/system registrations since they're now handled in MicroscopeApp
        setupBackgroundMusic()
    }
    
    // Immersive space IDs
    let labSpaceID = "ImmersiveSpace"
    let adcSpaceID = "ADCSpace"
    
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    
    var immersiveSpaceState: ImmersiveSpaceState = .closed
    var currentSpaceID: String?  // Track which space is currently open
    
    private func setupBackgroundMusic() {
        guard let musicURL = Bundle.main.url(forResource: "Daylight", withExtension: "mp3") else {
            print("Could not find background music file")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: musicURL)
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            audioPlayer?.volume = 0.5 // Set to 50% volume
            audioPlayer?.play()
        } catch {
            print("Could not create audio player: \(error.localizedDescription)")
        }
    }
    
    // Add method to control audio
    func toggleBackgroundMusic(isPlaying: Bool) {
        if isPlaying {
            audioPlayer?.play()
        } else {
            audioPlayer?.pause()
        }
    }
}
