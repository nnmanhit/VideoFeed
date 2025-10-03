//
//  VideoFeedManager.swift
//  VideoFeed
//
//  Created by Manh Nguyen on 10/2/25.
//

class VideoFeedUseCase : VideoFeedUseCaseProtocol {
    
    let videoFeedService : VideoFeedServiceProtocol
    
    init(videoFeedService: VideoFeedServiceProtocol) {
        self.videoFeedService = videoFeedService
    }
    
    func loadInitialVideos() async throws -> [VideoFeed] {
        
        do {
            
            let urls = try await videoFeedService.loadVideoFeeds()
            return urls.compactMap({ VideoFeed(url: $0) })
            
        } catch {
            throw error
        }
        
    }
    
    func sendMessage(_ message: String, videoId: String) async {
        await videoFeedService.sendMessage(message, videoId: videoId)
    }
    
    func likeVideo(_ videoId: String) async {
        await videoFeedService.likeVideo(videoId)
    }

}
