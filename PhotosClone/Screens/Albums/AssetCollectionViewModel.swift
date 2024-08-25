//
//  AssetCollectionViewModel.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/24/24.
//

import Foundation
import Photos
import Combine

final class AssetCollectionViewModel: ObservableObject {
    @Published var userAlbums: PHFetchResult<PHAssetCollection> = .init()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let libraryService: LibraryService
    
    init(libraryService: LibraryService) {
        self.libraryService = libraryService
        subscribe()
    }
    
    private func subscribe() {
        libraryService.$userAlbum
            .receive(on: DispatchQueue.main)
            .sink { [weak self] albums in
                self?.userAlbums = albums
            }
            .store(in: &cancellables)
    }
}

// MARK: Interfaces
extension AssetCollectionViewModel {
    func selectAlbum(_ collection: PHAssetCollection) {
        let assets = PHAsset.fetchAssets(in: collection, options: nil)
        libraryService.assets = assets
    }
}
