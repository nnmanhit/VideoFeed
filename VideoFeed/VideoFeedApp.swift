//
//  VideoFeedApp.swift
//  VideoFeed
//
//  Created by Manh Nguyen on 10/1/25.
//

import SwiftUI

@main
struct VideoFeedApp: App {
    var body: some Scene {
        WindowGroup {
            VideoFeedHomeView(viewModel: VideoFeedHomeViewModel(videoFeedUseCase: VideoFeedUseCase(videoFeedService: VideoFeedService())))
        }
    }
}
