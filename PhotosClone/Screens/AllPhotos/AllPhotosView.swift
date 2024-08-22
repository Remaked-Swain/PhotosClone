//
//  AllPhotosView.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/20/24.
//

import SwiftUI
import Photos

struct AllPhotosView: View {
    @EnvironmentObject private var libraryService: LibraryService
    @State var assetsCreationDateText: String = ""
    @State private var appearedAssetsDate: [Date] = [] {
        didSet {
            assetsCreationDateText = convertDateToString(min: appearedAssetsDate.min() ?? Date(), max: appearedAssetsDate.max() ?? Date())
        }
    }
    
    private let columns = [GridItem](repeating: .init(.flexible(), spacing: 2), count: 3)
    let assets: [PHAsset]
    
    init(assets: PHFetchResult<PHAsset>) {
        self.assets = assets.toArray()
    }
    
    var body: some View {
        ZStack {
            // Assets 목록
            GeometryReader { proxy in
                let width = proxy.size.width / 3
                let cellSize = CGSize(width: width, height: width)
                
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(assets, id: \.localIdentifier) { asset in
                            thumbnail(asset, cellSize)
                                .onAppear {
                                    libraryService.startCaching(for: assets, targetSize: cellSize)
                                }
                                .onDisappear {
                                    libraryService.stopCaching(for: assets, targetSize: cellSize)
                                }
                        }
                    }
                }
                .defaultScrollAnchor(.bottom)
            }
            
            // 제목 및 날짜
            VStack(alignment: .leading, spacing: 10) {
                Text("보관함")
                    .font(.title.bold())
                Text(assetsCreationDateText)
                    .font(.headline)
            }
            .shadow(radius: 4)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
    }
    
    @ViewBuilder private func thumbnail(_ asset: PHAsset, _ size: CGSize) -> some View {
        NavigationLink {
            AssetDisplayView(asset: asset)
        } label: {
            ThumbnailView(asset: asset, size: size, contentMode: .fill)
                .onAppear {
                    guard let date = asset.creationDate else { return }
                    appearedAssetsDate.append(date)
                }
                .onDisappear {
                    guard let date = asset.creationDate else { return }
                    appearedAssetsDate.removeAll { date == $0 }
                }
        }
    }
    
    private func convertDateToString(min: Date, max: Date) -> String {
        let calendar = Calendar.current
        let min = calendar.dateComponents([.day, .month, .year], from: min)
        let max = calendar.dateComponents([.day, .month, .year], from: max)
        
        if min.year != max.year {
            return "\(min.year ?? 0)년 \(min.month ?? 0)월 \(min.day ?? 0)일 ~ \(max.year ?? 0)년 \(max.month ?? 0)월 \(max.day ?? 0)일"
        } else if min.month != max.month {
            return "\(min.year ?? 0)년 \(min.month ?? 0)월 \(min.day ?? 0)일 ~ \(max.month ?? 0)월 \(max.day ?? 0)일"
        } else if min.day != max.day {
            return "\(min.year ?? 0)년 \(min.month ?? 0)월 \(min.day ?? 0)일 ~ \(max.day ?? 0)일"
        } else {
            return "\(min.year ?? 0)년 \(min.month ?? 0)월 \(min.day ?? 0)일"
        }
    }
}

#Preview {
    MainView()
        .environmentObject(LibraryService())
}
