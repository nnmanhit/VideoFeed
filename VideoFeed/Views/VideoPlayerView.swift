//
//  VideoPlayerView.swift
//  VideoFeed
//
//  Created by Manh Nguyen on 10/2/25.
//

import SwiftUI
import AVFoundation
import AVKit

struct VideoFeedView: View {
    @ObservedObject var videoFeed : VideoFeed
    var player : AVPlayer?
    var currentVideoProgress: Double
    
    init(videoFeed: VideoFeed, player: AVPlayer?, currentVideoProgress: Double) {
        self.videoFeed = videoFeed
        self.player = player
        self.currentVideoProgress = currentVideoProgress
    }

    var body: some View {
        
        ZStack {
            CustomVideoFeedPlayer(player: player)
                .containerRelativeFrame([.horizontal, .vertical])
            
            VStack {
                
                ProgressView(value: currentVideoProgress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .white))
                    .scaleEffect(x: 1, y: 1, anchor: .center)
                    .padding(.horizontal)
                    .padding(EdgeInsets(top: 60, leading: 0, bottom: 0, trailing: 0))
                    .accessibilityLabel("Video progress view")
                
                ProfileView(imageName: "ic_profile", size: 50, borderWidth: 3.0, borderColor: Color.teal)
                    .padding()
                    .accessibilityLabel("Profile view")
                
                Spacer()
                
            }
        }
        
    }
}

struct CustomVideoFeedPlayer : UIViewControllerRepresentable {
    
    var player : AVPlayer?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        let controller = AVPlayerViewController()
        controller.player = self.player
        controller.showsPlaybackControls = false
        controller.exitsFullScreenWhenPlaybackEnds = true
        controller.allowsPictureInPicturePlayback = true
        controller.videoGravity = .resizeAspectFill
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}
