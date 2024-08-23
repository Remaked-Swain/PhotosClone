//
//  AllPhotosView.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/20/24.
//

import SwiftUI
import Photos

struct AllPhotosView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: AllPhotosViewModel
    
    private let columns = [GridItem](repeating: .init(.flexible(), spacing: 2), count: 3)
    
    init(_ viewModel: AllPhotosViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            // Assets 목록
            GeometryReader { proxy in
                let width = proxy.size.width / 3
                let cellSize = CGSize(width: width, height: width)
                
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(viewModel.assets, id: \.id) { asset in
                            router.view(to: .thumbnailView(asset: asset, size: cellSize, contentMode: .fill))
                                .onAppear {
                                    viewModel.appendDate(asset.creationDate)
                                }
                                .onDisappear {
                                    viewModel.removeDate(asset.creationDate)
                                }
                                .onTapGesture {
                                    router.route(to: .assetDisplayView(asset: asset))
                                }
                        }
                    }
                }
                .onAppear {
                    viewModel.startCaching(targetSize: cellSize)
                }
                .onDisappear {
                    viewModel.stopCaching(targetSize: cellSize)
                }
                .defaultScrollAnchor(.bottom)
            }
            
            // 제목 및 날짜
            VStack(alignment: .leading, spacing: 10) {
                Text("보관함")
                    .font(.title.bold())
                Text(viewModel.assetsCreationDateText)
                    .font(.headline)
            }
            .shadow(radius: 4)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
    }
}
