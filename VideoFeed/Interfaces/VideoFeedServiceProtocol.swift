//
//  VideoFeedServiceProtocol.swift
//  VideoFeed
//
//  Created by Manh Nguyen on 10/1/25.
//

import Foundation

protocol VideoFeedServiceProtocol {
    
    func sendRequest(_ request: APIRequest) async throws -> Data?
    func loadVideoFeeds() async throws -> [URL]
    
    func sendMessage(_ message: String, videoId: String) async
    func likeVideo(_ videoId: String) async
    
}
