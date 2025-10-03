//
//  VideoFeedHomeView.swift
//  VideoFeed
//
//  Created by Manh Nguyen on 10/1/25.
//

import SwiftUI
import Combine
import AVFoundation

struct VideoFeedHomeView: View {
    
    @StateObject var viewModel: VideoFeedHomeViewModel
    
    var body: some View {
        ZStack {
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.videos) { video in
                        VideoFeedView(videoFeed: video, player: viewModel.getPlayerByVideo(video.id).0, currentVideoProgress: video.id == viewModel.scrollPosition ? viewModel.playbackProgress : viewModel.playbackProgress)
                            .containerRelativeFrame(.vertical)
                            .clipped()
                            .id(video.id)
                            .onAppear(perform: {
                                viewModel.playCurrent()
                            })
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $viewModel.scrollPosition)
            .ignoresSafeArea()
            .scrollDisabled(viewModel.scrollDisabled)
            .onChange(of: viewModel.scrollPosition) { oldId, newId in
                
                print("DEBUG - oldId = \(oldId ?? "")")
                print("DEBUG - newId = \(newId ?? "")")
                
                let newIndex = self.viewModel.videos.firstIndex(where: { $0.id == newId })
                
                guard let newIndex = newIndex else {
                    return
                }
                
                self.viewModel.didScroll(to: newIndex)
                
            }
            
            if viewModel.isTyping == true {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.isTyping)
                    .onAppear(perform: {
                        self.viewModel.pauseVideo()
                    })
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            self.viewModel.tapOverlay()
                        }
                    )
            }
            
            VStack {
                Spacer()
                ZStack {
                    HStack(alignment: .bottom, spacing: 8) {
                        ChatInputView(message: $viewModel.comment, textViewHeight: $viewModel.textViewHeight, isTyping: $viewModel.isTyping
                        )
                        .transition(.scale.combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.2), value: viewModel.isTyping)
                        .accessibilityLabel("Message Input View")
                        
                        if !viewModel.isTyping {
                            
                            Button(action: {
                                self.viewModel.likeVideo()
                            }) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.clear)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle()
                                            .stroke(Color.white, lineWidth: 1)
                                    }
                            }
                            .scaleEffect(1.1)
                            .accessibilityLabel("Like Button")
                            
                        }
                        
                        if (viewModel.comment.isEmpty && !viewModel.isTyping) || (!viewModel.comment.isEmpty) {
                            Button(action: {
                                viewModel.sendMessage()
                            }) {
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.clear)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle()
                                            .stroke(Color.white, lineWidth: 1)
                                    }
                            }
                            .accessibilityLabel("Send Button")
                        }
                    }
                    .padding()
                    .background(.clear)
                    
                    if viewModel.comment.isEmpty {
                        Text("Send Message")
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 0, leading: -180, bottom: 0, trailing: 0))
                            .accessibilityLabel("Text Placeholder")
                    }
                    Spacer()
                }
            }
            
        }
    }
    
}
