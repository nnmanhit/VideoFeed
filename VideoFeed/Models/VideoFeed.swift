//
//  VideoFeed.swift
//  VideoFeed
//
//  Created by Manh Nguyen on 10/1/25.
//

import Foundation
import AVFoundation

class VideoFeed : ObservableObject, Identifiable {
    
    private(set) var url : URL
    
    var id : String {
        return url.absoluteString
    }
    
    init(url: URL) {
        self.url = url
    }
    
}
