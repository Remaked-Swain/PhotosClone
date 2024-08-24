//
//  Route.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/23/24.
//

import SwiftUI
import Photos

protocol Routable: Identifiable, Hashable {
    associatedtype Content: View
    associatedtype Router: AppRouter
    
    var presentingType: PresentingType { get }
    
    @ViewBuilder func view(with router: Router) -> Content
}

extension Routable {
    var id: String { String(describing: self) }
}

enum PresentingType {
    case push
}

enum Route: Routable {
    typealias Router = DefaultAppRouter
    
    // View
    case routerView
    case mainView
    case allPhotosView
    case assetDisplayView
    case assetCollectionView
    
    // ComponentsView
    case thumbnailView(asset: PHAsset, size: CGSize, contentMode: ContentMode)
    case videoPlayerView(asset: PHAsset)
    
    var presentingType: PresentingType { .push }
    
    @ViewBuilder func view(with router: DefaultAppRouter) -> some View {
        switch self {
            // View
        case .routerView:
            RouterView<Router>(router: router, root: .mainView)
        case .mainView:
            MainView<Router>(router.resolver.resolve(MainViewModel.self))
        case .allPhotosView:
            AllPhotosView<Router>(router.resolver.resolve(AllPhotosViewModel.self))
        case .assetDisplayView:
            AssetDisplayView<Router>(router.resolver.resolve(AssetDisplayViewModel.self))
        case .assetCollectionView:
            AssetCollectionView<Router>(router.resolver.resolve(AssetCollectionViewModel.self))
            
            // ComponentsView
        case .thumbnailView(let asset, let size, let contentMode):
            ThumbnailView<Router>(router.resolver.resolve(ThumbnailViewModel.self), asset: asset, size: size, contentMode: contentMode)
        case .videoPlayerView(let asset):
            VideoPlayerView<Router>(router.resolver.resolve(VideoPlayerViewModel.self), asset: asset)
        }
    }
}

// MARK: Equatable Conformation
extension Route: Equatable {
    static func == (lhs: Route, rhs: Route) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

// MARK: Hashable Conformation
extension Route: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
