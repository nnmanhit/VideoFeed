//
//  VideoFeedResponse.swift
//  VideoFeed
//
//  Created by Manh Nguyen on 10/1/25.
//

import Foundation

struct VideoFeedResponse : Codable {
    
    let videos : [String]?
    
    func getVideoURLs() -> [URL] {
        return videos?.compactMap({ URL(string: $0) }).compactMap({ $0 }) ?? []
    }
    
}
