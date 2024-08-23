//
//  AssetDisplayViewModel.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/23/24.
//

import Foundation
import Photos
import Combine


//Publishing changes from within view updates is not allowed, this will cause undefined behavior.
final class AssetDisplayViewModel: ObservableObject {
    @Published var fetchResult: PHFetchResult<PHAsset> = .init()
    @Published var currentIndex: Int = 0 {
        didSet { displayAssetInfo() }
    }
    @Published var assetInfoTitle: String = ""
    @Published var assetInfoSubtitle: String = ""
    @Published var isFavorite: Bool = false

    private var cancellables = Set<AnyCancellable>()
    
    private let libraryService: LibraryService
    
    init(libraryService: LibraryService) {
        self.libraryService = libraryService
        subscribe()
    }
    
    private func subscribe() {
        libraryService.$assets
            .receive(on: DispatchQueue.main)
            .sink { [weak self] assets in
                self?.fetchResult = assets
            }
            .store(in: &cancellables)
    }
    
    private func displayAssetInfo() {
        let asset = fetchResult[currentIndex]
        assetInfoTitle = asset.creationDate?.toString(by: .yyyyMMddKorean) ?? "사진"
        assetInfoSubtitle = asset.creationDate?.toString(by: .HHmm) ?? ""
    }
}

// MARK: Interfaces
extension AssetDisplayViewModel {
    func startCaching(targetSize: CGSize) {
        libraryService.startCaching(for: fetchResult.toArray(), targetSize: targetSize)
    }
    
    func stopCaching(targetSize: CGSize) {
        libraryService.stopCaching(for: fetchResult.toArray(), targetSize: targetSize)
    }
    
    @MainActor func deleteAsset() {
        Task {
            try? await libraryService.deleteAsset(for: fetchResult[currentIndex])
        }
    }
    
    @MainActor func toggleFavorite() {
        Task {
            try? await libraryService.toggleAssetFavorite(for: fetchResult[currentIndex])
        }
    }
}
