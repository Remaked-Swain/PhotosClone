//
//  ThumbnailView.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/22/24.
//

import SwiftUI
import Photos

struct ThumbnailView: View {
    @EnvironmentObject private var libraryService: LibraryService
    
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
            // 이미 로드된 이미지가 있으면 다시 가져올 필요 없음
            guard image == nil else { return }
            let imageData = await libraryService.requestImage(for: asset, targetSize: size, contentMode: imageContentMode)
            guard let uiImage = imageData?.image else { return }
            image = Image(uiImage: uiImage)
        }
    }
}
