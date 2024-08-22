//
//  PhotosCloneApp.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/20/24.
//

import SwiftUI

@main
struct PhotosCloneApp: App {
    @StateObject private var libraryService = LibraryService()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView()
                    .environmentObject(libraryService)
            }
        }
    }
}
