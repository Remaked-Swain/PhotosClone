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
    @Published var navigationBarTitleDisplayMode: NavigationBarItem.TitleDisplayMode = .automatic
    
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
                self?.navigationBarTitleDisplayMode = screenType.navigationBarTitleDisplayMode
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
