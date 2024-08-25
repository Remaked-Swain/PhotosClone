//
//  AssetCollectionView.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/24/24.
//

import SwiftUI
import Photos

struct AssetCollectionView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: AssetCollectionViewModel
    
    init(_ viewModel: AssetCollectionViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            section(for: .userAlbum)
            section(for: .mediaType)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder private func section(for type: CollectionType) -> some View {
        switch type {
        case .userAlbum:
            userAlbumSection(type.categories)
        case .mediaType:
            otherAlbumsSection(type.categories)
        }
    }
    
    @ViewBuilder private func userAlbumSection(_ categories: [AlbumCategory]) -> some View {
        Section {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 10) {
                    ForEach(categories, id: \.id) { category in
                        albumCover(category)
                    }
                }
            }
            .defaultScrollAnchor(.leading)
        } header: {
            header("나의 앨범")
        }
        .padding(.bottom)
    }
    
    @ViewBuilder private func otherAlbumsSection(_ categories: [AlbumCategory]) -> some View {
        Section {
            ForEach(categories, id: \.id) { category in
                let iconName = category.iconName
                if let collection = category.assetCollection {
                    let assets = PHAsset.fetchAssets(in: collection, options: nil)
                    
                    HStack {
                        HStack {
                            Image(systemName: iconName)
                            Text(collection.localizedTitle ?? "새 항목")
                        }
                        .foregroundStyle(Color.accentColor)
                        
                        Spacer()
                        
                        HStack {
                            Text("\(assets.count)")
                            Image(systemName: "chevron.right")
                        }
                        .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 10)
                    .contentShape(.rect)
                    .onTapGesture {
                        router.route(to: .allPhotosView(assets: assets.toArray()))
                    }
                }
            }
        } header: {
            header("미디어 유형")
        }
    }
    
    @ViewBuilder private func header(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.title2.bold())
            
            Spacer()
        }
    }
    
    @ViewBuilder private func albumCover(_ category: AlbumCategory) -> some View {
        if let collection = category.assetCollection {
            let assets = PHAsset.fetchAssets(in: collection, options: nil)
            VStack(alignment: .leading) {
                if let asset = assets.firstObject {
                    router.view(to: .thumbnailView(asset: asset, size: CGSize(width: 150, height: 150), contentMode: .fill))
                } else {
                    Image(systemName: "photo.on.rectangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                }
                
                Text(collection.localizedTitle ?? "새로운 앨범")
                    .font(.caption)
                
                Text("\(assets.count)")
                    .font(.caption)
            }
            .onTapGesture {
                viewModel.selectAlbum(collection)
                router.route(to: .allPhotosView(assets: assets.toArray()))
            }
        }
    }
}

#Preview {
    NavigationStack {
        AssetCollectionView<DefaultAppRouter>(AssetCollectionViewModel(libraryService: LibraryService()))
            .environmentObject(DefaultAppRouter(by: CommonAssembly()))
    }
}
