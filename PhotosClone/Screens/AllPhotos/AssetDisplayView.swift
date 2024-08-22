//
//  AssetDisplayView.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/23/24.
//

import SwiftUI
import Photos

struct AssetDisplayView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var librarySerivce: LibraryService
    let asset: PHAsset
    
    var body: some View {
        VStack {
            // 제목 및 날짜
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    if let date = asset.creationDate {
                        Text(date.toString(by: .yyyyMMddKorean))
                            .font(.title3.bold())
                        Text(date.toString(by: .HHmm))
                            .font(.footnote)
                    }
                }
                
                Spacer()
                
                StrokedButton(.circle) {
                    Image(systemName: "xmark")
                } action: {
                    dismiss()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            Spacer()
            
            // AssetContent
            GeometryReader { proxy in
                Group {
                    assetContent(asset, targetSize: proxy.size)
                }
            }
            
            Spacer()
            
            // Hovering Controller
            HStack {
                
            }
        }
        .padding()
    }
    
    @ViewBuilder private func assetContent(_ asset: PHAsset, targetSize: CGSize) -> some View {
        switch asset.mediaType {
        case .image, .unknown:
            ThumbnailView(asset: asset, size: targetSize, contentMode: .fit)
        case .audio, .video:
            VideoPlayerView(asset: asset)
        @unknown default:
            ContentUnavailableView("표시할 수 없음.", image: "questionmark", description: Text("알 수 없는 미디어 파일이기 때문에 표시할 수 없습니다."))
        }
    }
}
