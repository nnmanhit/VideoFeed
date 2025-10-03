//
//  VideoFeedUseCaseProtocol.swift
//  VideoFeed
//
//  Created by Manh Nguyen on 10/2/25.
//

import Combine

protocol VideoFeedUseCaseProtocol {
    
    func loadInitialVideos() async throws -> [VideoFeed]
 
    func sendMessage(_ message: String, videoId: String) async
    
    func likeVideo(_ videoId: String) async
    
}
