//
//  AllPhotosViewModel.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/23/24.
//

import Foundation
import Photos
import Combine

final class AllPhotosViewModel: ObservableObject {
    @Published var assets: [PHAsset] = []

    @Published var assetsCreationDateText: String = ""
    private var appearedAssetsDate: [Date] = [] {
        didSet {
            assetsCreationDateText = convertDateToString(min: appearedAssetsDate.min() ?? Date(), max: appearedAssetsDate.max() ?? Date())
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let libraryService: LibraryService
    
    init(libraryService: LibraryService) {
        self.libraryService = libraryService
        subscribe()
    }
    
    private func subscribe() {
        libraryService.$assets
            .map { $0.toArray() }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] assets in
                self?.assets = assets
            }
            .store(in: &cancellables)
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

// MARK: Interfaces
extension AllPhotosViewModel {
    func appendDate(_ date: Date?) {
        guard let date = date else { return }
        appearedAssetsDate.append(date)
    }
    
    func removeDate(_ date: Date?) {
        guard let date = date else { return }
        appearedAssetsDate.removeAll { date == $0 }
    }
    
    func startCaching(targetSize: CGSize) {
        libraryService.startCaching(for: assets, targetSize: targetSize)
    }
    
    func stopCaching(targetSize: CGSize) {
        libraryService.stopCaching(for: assets, targetSize: targetSize)
    }
    
    func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode) async -> ImageData? {
        await libraryService.requestImage(for: asset, targetSize: targetSize, contentMode: contentMode)
    }
    
    func selectAsset(_ asset: PHAsset) {
        libraryService.selectedAsset = asset
    }
}
