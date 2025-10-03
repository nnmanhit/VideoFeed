//
//  VideoFeedHomeViewModelProtocol.swift
//  VideoFeed
//
//  Created by Manh Nguyen on 10/1/25.
//

import Combine

protocol VideoFeedHomeViewModelProtocol : ObservableObject {
    
    func loadInitialVideos() async
    
}
