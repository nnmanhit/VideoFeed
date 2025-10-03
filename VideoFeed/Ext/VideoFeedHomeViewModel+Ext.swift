//
//  VideoFeedHomeViewModel+Ext.swift
//  VideoFeed
//
//  Created by Manh Nguyen on 10/3/25.
//

import AVFoundation
import UIKit

extension VideoFeedHomeViewModel {
    
    @objc func playerItemDidFinishPlaying(notification: Notification) {

        self.playCurrent()
        
    }
    
    func startPlaybackTimeObserver() {
        stopPlaybackTimeObserver()
        
        guard let avPlayer = players[currentIndex] else { return }
        let interval = CMTime(seconds: 0.25, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let token = avPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self, let item = avPlayer.currentItem else { return }
            let duration = CMTimeGetSeconds(item.duration)
            if duration > 0 {
                self.playbackProgress = CMTimeGetSeconds(time) / duration
            }
        }
        timeObserver = (avPlayer, token)
    }

    func stopPlaybackTimeObserver() {
        if let (player, token) = timeObserver {
            player.removeTimeObserver(token)
        }
        timeObserver = nil
    }
    
    func pauseVideo() {
        if let player = players[currentIndex] {
            player.pause()
        }
        scrollDisabled = true
    }
    
    func playVideo() {
        isTyping = false
        self.playCurrent()
        scrollDisabled = false
        hideKeyboard()
    }
    
    func getPlayerByVideo(_ videoId: String) -> (AVPlayer?, Int) {
        if let index = self.videos.firstIndex(where: { $0.id == videoId }) {
            return (self.players[index], index)
        }
        return (nil, 0)
    }
    
    func preloadPlayers() {
        guard !videos.isEmpty else { return }
        
        let halfWindow = Config.DEFAULT_VIDEO_CAPACITY / 2
        let start = max(currentIndex - halfWindow, 0)
        let end = min(currentIndex + halfWindow, videos.count - 1)
        let window = Array(start...end)
        
        // Remove players outside of the window
        for (idx, player) in players {
            if !window.contains(idx) {
                player.pause()
                
                // to avoid memory leak
                player.replaceCurrentItem(with: nil)
                
                if let item = player.currentItem {
                    NotificationCenter.default.removeObserver(
                        self,
                        name: .AVPlayerItemDidPlayToEndTime,
                        object: item
                    )
                }
                
                players.removeValue(forKey: idx)
            }
        }
        
        // Preload missing players inside the window
        for idx in window where players[idx] == nil {
            let player = AVPlayer(url: videos[idx].url)
            players[idx] = player
            
            if let item = player.currentItem {
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(playerItemDidFinishPlaying),
                    name: .AVPlayerItemDidPlayToEndTime,
                    object: item // Specify the exact item to watch
                )
            }
            
        }
    }
    
    func playCurrent() {
        stopAll()
        if let player = players[currentIndex] {
            player.seek(to: .zero)
            player.play()
            
            self.startPlaybackTimeObserver()
        }
    }
    
    func stopAll() {
        for player in players.values {
            player.pause()
        }
    }
    
    func didScroll(to newIndex: Int) {
        guard newIndex != currentIndex else { return }
        
        print(newIndex)
        print(currentIndex)
        
        currentIndex = newIndex
        preloadPlayers()
        playCurrent()
    }
    
    func likeVideo() {
        
        Task {
            let avPlayer = players[currentIndex]
            
            let url = await (avPlayer?.currentItem?.asset as? AVURLAsset)?.url
            if let url = url {
                await self.likeVideo(url.absoluteString)
            }
        }
        
    }
    
    func tapOverlay() {
        
        if self.isTyping {
            // First resign keyboard
            self.hideKeyboard()
            
            // Then hide overlay & resume video immediately
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.playVideo()
            }
        }
        
    }
    
    func sendMessage() {
        
        Task {
            
            let avPlayer = players[currentIndex]
            
            let url = await (avPlayer?.currentItem?.asset as? AVURLAsset)?.url
            if let url = url {
                await self.sendMessage(self.comment, videoId: url.absoluteString)
            }
            
            await MainActor.run() {
                comment = ""
                isTyping = false
                
                hideKeyboard()
                
                self.playVideo()
            }
            
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
