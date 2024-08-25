//
//  MainViewModel.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/23/24.
//

import SwiftUI
import Photos
import Combine

final class MainViewModel: ObservableObject {
    @Published var isAlertPresented: Bool = false
    @Published var selectedTab: ScreenType = .allPhotos
    @Published var navigationTitle: String = ""
    @Published var assets: [PHAsset] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private let libraryService: LibraryService
    
    init(libraryService: LibraryService) {
        self.libraryService = libraryService
        subscribe()
    }
    
    private func subscribe() {
        $selectedTab
            .sink { [weak self] screenType in
                self?.navigationTitle = screenType.navigationTitle
            }
            .store(in: &cancellables)
        
        libraryService.$assets
            .map { $0.toArray() }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] assets in
                self?.assets = assets
            }
            .store(in: &cancellables)
    }
}

// MARK: Interfaces
extension MainViewModel {
    func requestAuthorizationIfNeeded() async throws {
        try await libraryService.requestAuthorizationIfNeeded()
    }
}
