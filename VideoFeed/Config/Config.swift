//
//  Config.swift
//  VideoFeed
//
//  Created by Manh Nguyen on 10/1/25.
//

struct Config {
    
    static let env : Env = .Prod
    
    static let DEFAULT_VIDEO_CAPACITY = 5
    
    static func getVideoCapacity() -> Int {
        // Should be flexible by device model here
        // New models usually stronger and faster, so capacity could be higher
        return DEFAULT_VIDEO_CAPACITY
    }
    
}

struct APIConfig {
    
    static func getBaseUrl() -> String {
        
        if Config.env == .Prod {
            return CDN_PROD_BASE_URL
        }
        
        return CDN_STAGING_BASE_URL
        
    }
    
    static func getVideosUrl() -> String {
        return self.getBaseUrl() + "AgentVideos-HLS-Progressive/manifest.json"
    }
    
}
