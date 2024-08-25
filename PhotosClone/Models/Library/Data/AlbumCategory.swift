//
//  AlbumCategory.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/24/24.
//

import Foundation
import Photos

enum AlbumCategory: CaseIterable, Identifiable {
    case recent
    case favorite
    case video
    case portraits
    case livePhoto
    case personMode
    case panorama
    case timelapse
    case slowMotion
    case burst
    case screenshot
    case animated
    
    var id: Int {
        self.hashValue
    }
    
    var iconName: String {
        switch self {
        case .video:
            "video"
        case .portraits:
            "person.crop.square"
        case .livePhoto:
            "livephoto"
        case .personMode:
            "florinsign.circle"
        case .panorama:
            "pano"
        case .timelapse:
            "timelapse"
        case .slowMotion:
            "slowmo"
        case .burst:
            "square.stack.3d.down.right"
        case .screenshot:
            "camera.viewfinder"
        case .animated:
            "square.stack.3d.forward.dottedline"
        default:
            ""
        }
    }
    
    var subtype: PHAssetCollectionSubtype {
        switch self {
        case .recent:
                .smartAlbumRecentlyAdded
        case .favorite:
                .smartAlbumFavorites
        case .video:
                .smartAlbumVideos
        case .portraits:
                .smartAlbumSelfPortraits
        case .livePhoto:
                .smartAlbumLivePhotos
        case .personMode:
                .smartAlbumDepthEffect
        case .panorama:
                .smartAlbumPanoramas
        case .timelapse:
                .smartAlbumTimelapses
        case .slowMotion:
                .smartAlbumSlomoVideos
        case .burst:
                .smartAlbumBursts
        case .screenshot:
                .smartAlbumScreenshots
        case .animated:
                .smartAlbumAnimated
        }
    }
    
    var assetCollection: PHAssetCollection? {
        let fetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: subtype, options: nil)
        guard fetchResult.count > 0 else { return nil }
        return fetchResult.object(at: .zero)
    }
}

enum CollectionType {
    case userAlbum
    case mediaType
    
    var categories: [AlbumCategory] {
        switch self {
        case .userAlbum: [.recent, .favorite]
        case .mediaType: [.video, .portraits, .livePhoto, .personMode, .panorama, .timelapse, .slowMotion, .burst, .screenshot, .animated]
        }
    }
}
