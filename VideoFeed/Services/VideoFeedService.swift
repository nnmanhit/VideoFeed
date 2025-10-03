//
//  VideoFeedService.swift
//  VideoFeed
//
//  Created by Manh Nguyen on 10/1/25.
//

import Foundation
import Combine

struct VideoFeedService : VideoFeedServiceProtocol {
    
    func loadVideoFeeds() async throws -> [URL] {
        
        guard let videoURL = URL(string: APIConfig.getVideosUrl()) else {
            throw APIError.InvalidURL
        }
        
        let request = APIRequest(url: videoURL)
        let data = try await self.sendRequest(request)
        
        do {
            if let data = data {
                let videoFeedResponse = try JSONDecoder().decode(VideoFeedResponse.self, from: data)
                let videoUrls = videoFeedResponse.getVideoURLs()
                return videoUrls
            } else {
                throw APIError.InvalidResponse(statusCode: 404)
            }
        } catch {
            throw APIError.InvalidDataFormat
        }
        
    }
    
    func sendRequest(_ request: APIRequest) async throws -> Data? {
        
        do {
            
            let (data, response) = try await URLSession.shared.data(from: request.url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.InvalidResponse(statusCode: -1)
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                return data
            default:
                throw APIError.InvalidResponse(statusCode: httpResponse.statusCode)
            }
            
        } catch {
            throw APIError.InvalidURL
        }
        
        
    }
    
    func sendMessage(_ message: String, videoId: String) async {
        // TODO
    }
    
    func likeVideo(_ videoId: String) async {
        // TODO
    }
    
}
