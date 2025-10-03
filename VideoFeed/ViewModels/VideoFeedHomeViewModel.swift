//
//  VideoFeedHomeViewModel.swift
//  VideoFeed
//
//  Created by Manh Nguyen on 10/1/25.
//

import Combine
import UIKit
import AVFoundation

class VideoFeedHomeViewModel : VideoFeedHomeViewModelProtocol {
    
    @Published var errorMessage : String? = nil
    @Published var isLoadingData : Bool = false
    @Published var videos : [VideoFeed] = []
    
    @Published var currentIndex: Int = 0
    @Published var players: [Int: AVPlayer] = [:]  // keyed by index
    
    @Published var scrollPosition: String?
    @Published var scrollDisabled : Bool = false
    @Published var isTyping : Bool = false
    @Published var isPausingVideo : Bool = false
    @Published var isShowingPlayButton : Bool = false
    @Published var comment: String = ""
    @Published var textViewHeight: CGFloat = 45
    @Published var playbackProgress: Double = 0.0
    @Published var timeObserverToken: Any?
    
    var timeObserver: (player: AVPlayer, token: Any)?

    let videoFeedUseCase : VideoFeedUseCaseProtocol
    init(videoFeedUseCase: VideoFeedUseCaseProtocol) {
        self.videoFeedUseCase = videoFeedUseCase
        Task {
            await self.loadInitialVideos()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadInitialVideos() async {
        
        do {
            
            await MainActor.run {
                self.isLoadingData = true
            }
            
            let videos = try await videoFeedUseCase.loadInitialVideos()
            
            await MainActor.run {
                self.isLoadingData = false
                self.videos = videos
                self.preloadPlayers()
            }
            
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
        
    }
    
    func sendMessage(_ message: String, videoId: String) async {
        await self.videoFeedUseCase.sendMessage(message, videoId: videoId)
    }
    
    func likeVideo(_ videoId: String) async {
        await self.videoFeedUseCase.likeVideo(videoId)
    }
    
}
