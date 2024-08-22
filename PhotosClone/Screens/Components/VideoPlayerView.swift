//
//  VideoPlayerView.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/23/24.
//

import SwiftUI
import Photos
import AVKit

struct VideoPlayerView: View {
    @EnvironmentObject private var libraryService: LibraryService
    @State private var playerItem: AVPlayerItem?
    
    let asset: PHAsset
    
    var body: some View {
        VideoPlayer(player: AVPlayer(playerItem: playerItem))
            .task {
                let videoData = await libraryService.requestVideo(for: asset)
                guard let playerItem = videoData?.playerItem else { return }
                self.playerItem = playerItem
            }
    }
}
