//
//  VideoPlayerView.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/23/24.
//

import SwiftUI
import Photos
import AVKit

final class VideoPlayerViewModel: ObservableObject {
    @Published var playerItem: AVPlayerItem?
    
    private let libraryService: LibraryService
    
    init(libraryService: LibraryService) {
        self.libraryService = libraryService
    }
    
    func fetchVideo(_ asset: PHAsset) async {
        let videoData = await libraryService.requestVideo(for: asset)
        guard let playerItem = videoData?.playerItem else { return }
        self.playerItem = playerItem
    }
}

struct VideoPlayerView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: VideoPlayerViewModel
    
    let asset: PHAsset
    
    init(
        _ viewModel: VideoPlayerViewModel,
        asset: PHAsset
    ) {
        self.viewModel = viewModel
        self.asset = asset
    }
    
    var body: some View {
        VideoPlayer(player: AVPlayer(playerItem: viewModel.playerItem))
            .task {
                await viewModel.fetchVideo(asset)
            }
    }
}
