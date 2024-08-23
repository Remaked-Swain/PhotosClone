//
//  ThumbnailView.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/22/24.
//

import SwiftUI
import Photos

final class ThumbnailViewModel: ObservableObject {
    @Published var image: Image?
    
    private let librarySerivce: LibraryService
    
    init(libraryService: LibraryService) {
        self.librarySerivce = libraryService
    }
    
    func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode) async -> ImageData? {
        await librarySerivce.requestImage(for: asset, targetSize: targetSize, contentMode: contentMode)
    }
}

struct ThumbnailView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: ThumbnailViewModel
    @State private var image: Image?
    
    private var imageContentMode: PHImageContentMode {
        switch contentMode {
        case .fit: .aspectFit
        case .fill: .aspectFill
        }
    }
    
    let asset: PHAsset
    let size: CGSize
    let contentMode: ContentMode
    
    init(
        _ viewModel: ThumbnailViewModel,
        image: Image? = nil,
        asset: PHAsset,
        size: CGSize,
        contentMode: ContentMode
    ) {
        self.viewModel = viewModel
        self.image = image
        self.asset = asset
        self.size = size
        self.contentMode = contentMode
    }
    
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: contentMode)
                    .frame(width: size.width, height: size.height)
                    .clipped()
            } else {
                Rectangle()
                    .background(.thickMaterial)
                    .frame(width: size.width, height: size.height)
            }
        }
        .task {
            let imageData = await viewModel.requestImage(for: asset, targetSize: size, contentMode: imageContentMode)
            guard let uiImage = imageData?.image else { return }
            image = Image(uiImage: uiImage)
        }
        .onChange(of: viewModel.image) {
            self.image = viewModel.image
        }
    }
}
