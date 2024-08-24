//
//  MainViewModel.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/23/24.
//

import Foundation
import Photos

final class MainViewModel: ObservableObject {
    @Published var isAlertPresented: Bool = false
    @Published var selectedTab: ScreenType = .allPhotos
    
    private let libraryService: LibraryService
    
    init(libraryService: LibraryService) {
        self.libraryService = libraryService
    }
}

// MARK: Interfaces
extension MainViewModel {
    func requestAuthorizationIfNeeded() async throws {
        try await libraryService.requestAuthorizationIfNeeded()
    }
}
