//
//  AssetDisplayView.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/23/24.
//

import SwiftUI
import Photos

struct AssetDisplayView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: AssetDisplayViewModel
    
    init(_ viewModel: AssetDisplayViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            // 제목 및 날짜
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.assetInfoTitle)
                        .font(.title3.bold())
                    Text(viewModel.assetInfoSubtitle)
                        .font(.footnote)
                }
                
                Spacer()
                
                Button {
                    router.dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
            .shadow(radius: 4)
            
            // 대표 이미지
            TabView(selection: $viewModel.currentIndex) {
                ForEach(0..<viewModel.fetchResult.count, id: \.self) { index in
                    GeometryReader { proxy in
                        assetContent(viewModel.fetchResult.object(at: index), targetSize: proxy.size)
                            .tag(index)
                    }
                }
                .padding()
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // 하단 Carousel
            ScrollViewReader { proxy in
                let size = CGSize(width: 50, height: 50)
                
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(0..<viewModel.fetchResult.count, id: \.self) { index in
                            router.view(to: .thumbnailView(asset: viewModel.fetchResult[index], size: size, contentMode: .fill))
                                .frame(width: 50, height: 50)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.currentIndex = index
                                    }
                                }
                                .id(index)
                                .tag(index)
                        }
                    }
                    .frame(height: 50)
                }
                .scrollIndicators(.hidden)
                .onAppear {
                    viewModel.startCaching(targetSize: size)
                }
                .onDisappear {
                    viewModel.stopCaching(targetSize: size)
                }
                .onChange(of: viewModel.currentIndex) {
                    withAnimation {
                        proxy.scrollTo(viewModel.currentIndex, anchor: .center)
                    }
                }
            }
            
            // Hovering Controlls
            HStack(spacing: 20) {
                Button {
                    viewModel.toggleFavorite()
                } label: {
                    Image(systemName: "heart.fill")
                        .smallMaterialButton()
                }
                
                Spacer()
                
                Button {
                    viewModel.deleteAsset()
                } label: {
                    Image(systemName: "trash")
                        .smallMaterialButton()
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden()
    }

    @ViewBuilder private func assetContent(_ asset: PHAsset, targetSize: CGSize) -> some View {
        switch asset.mediaType {
        case .image, .unknown:
            router.view(to: .thumbnailView(asset: asset, size: targetSize, contentMode: .fit))
        case .audio, .video:
            router.view(to: .videoPlayerView(asset: asset))
        @unknown default:
            ContentUnavailableView("표시할 수 없음.", image: "questionmark", description: Text("알 수 없는 미디어 파일이기 때문에 표시할 수 없습니다."))
        }
    }
}
