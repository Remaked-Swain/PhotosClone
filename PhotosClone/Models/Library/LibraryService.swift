//
//  LibraryService.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/20/24.
//

import UIKit
import Photos

final class LibraryService: NSObject {
    private let sortOption: PhotoAssetSortOption = .creationDate
    @Published var assets: PHFetchResult<PHAsset> = .init()
    @Published var smartAlbums: PHFetchResult<PHAssetCollection> = .init()
    @Published var collections: PHFetchResult<PHCollection> = .init()
    private var status: PHAuthorizationStatus { PHPhotoLibrary.authorizationStatus(for: .readWrite) }
    
    // 이미지 요청 옵션 Shortcut
    private lazy var requestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        return options
    }()
    
    private let imageManager: PHCachingImageManager = .init()
    
    override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func requestAuthorizationIfNeeded() async throws {
        switch status {
        case .authorized:
            PHPhotoLibrary.shared().register(self)
            await fetchAssets()
        case .notDetermined, .limited:
            try await requestAuthorization()
        case .denied, .restricted:
            break
        @unknown default: fatalError("새로운 권한 상태에 대한 대응 필요")
        }
    }
    
    func fetchAssets() async {
        guard status == .authorized || status == .limited else { return }
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [sortOption.sortDescriptor(true)]
        fetchOptions.includeAssetSourceTypes = .typeUserLibrary
        
        await MainActor.run {
            assets = PHAsset.fetchAssets(with: fetchOptions)
            smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
            collections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        }
    }
}

// MARK: Private Methods
extension LibraryService {
    private func requestAuthorization() async throws {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        
        switch status {
        case .authorized:
            PHPhotoLibrary.shared().register(self)
            await fetchAssets()
        case .denied: 
            throw PHPhotosError(.accessUserDenied)
        case .restricted: 
            throw PHPhotosError(.accessRestricted)
        default: break
        }
    }
}

// MARK: ImageManager Interfaces
extension LibraryService {
    func startCaching(for assets: [PHAsset], targetSize: CGSize) {
        imageManager.startCachingImages(for: assets, targetSize: targetSize, contentMode: .default, options: requestOptions)
    }
    
    func stopCaching(for assets: [PHAsset], targetSize: CGSize) {
        imageManager.stopCachingImages(for: assets, targetSize: targetSize, contentMode: .default, options: requestOptions)
    }
    
    func stopCaching() {
        imageManager.stopCachingImagesForAllAssets()
    }
    
    func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode) async -> ImageData? {
        var requestId: PHImageRequestID?
        let (image, info): (UIImage?, [AnyHashable: Any]?) = await withCheckedContinuation { continuation in
            var continuation: CheckedContinuation<(UIImage?, [AnyHashable: Any]?), Never>? = continuation
            
            requestId = imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: requestOptions) { uiImage, info in
                continuation?.resume(returning: (uiImage, info))
                continuation = nil
            }
        }
        
        if let error = info?[PHImageErrorKey] as? Error {
            print(error)
            return nil
        }
        
        guard let image = image else { return nil }
        let isLowerQuality = (info?[PHImageResultIsDegradedKey] as? NSNumber)?.boolValue ?? false
        let imageData = ImageData(requestId: requestId, image: image, isLowerQuality: isLowerQuality)
        return imageData
    }
    
    func requestVideo(for asset: PHAsset) async -> VideoData? {
        var requestId: PHImageRequestID?
        let (playerItem, info): (AVPlayerItem?, [AnyHashable: Any]?) = await withCheckedContinuation { continuation in
            var continuation: CheckedContinuation<(AVPlayerItem?, [AnyHashable: Any]?), Never>? = continuation
            
            let requestOptions = PHVideoRequestOptions()
            requestOptions.deliveryMode = .highQualityFormat
            requestId = imageManager.requestPlayerItem(forVideo: asset, options: requestOptions) { playerItem, info in
                continuation?.resume(returning: (playerItem, info))
                continuation = nil
            }
        }
        
        if let error = info?[PHImageErrorKey] {
            print(error)
            return nil
        }
        
        guard let playerItem = playerItem else { return nil }
        let videoData = VideoData(requestId: requestId, playerItem: playerItem)
        return videoData
    }
    
    func deleteAsset(for assets: PHAsset...) async throws {
        let assets = assets as [PHAsset]
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets(assets as NSArray)
        }
    }
    
    func toggleAssetFavorite(for asset: PHAsset) async throws {
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest(for: asset).isFavorite = !asset.isFavorite
        }
    }
}

// MARK: PHPhotoLibraryChangeObserver Conformation
extension LibraryService: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        Task { @MainActor in
            if let assetsChange = changeInstance.changeDetails(for: assets) {
                assets = assetsChange.fetchResultAfterChanges
            }
            
            if let albumsChange = changeInstance.changeDetails(for: smartAlbums) {
                smartAlbums = albumsChange.fetchResultAfterChanges
            }
            
            if let collectionsChange = changeInstance.changeDetails(for: collections) {
                collections = collectionsChange.fetchResultAfterChanges
            }
        }
    }
}
