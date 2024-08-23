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
    case assetDisplayView(asset: PHAsset)
    
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
        case .assetDisplayView(let asset):
            AssetDisplayView<Router>(router.resolver.resolve(AssetDisplayViewModel.self), asset: asset)
            
            // ComponentsView
        case .thumbnailView(let asset, let size, let contentMode):
            let handler = router.resolver.resolve(AllPhotosViewModel.self).requestImage
            ThumbnailView<Router>(handler: handler, asset: asset, size: size, contentMode: contentMode)
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
