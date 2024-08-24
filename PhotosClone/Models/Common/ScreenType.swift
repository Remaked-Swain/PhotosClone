//
//  ScreenType.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/24/24.
//

import SwiftUI

enum ScreenType {
    case allPhotos
    case albums
    
    var label: Label<Text, Image> {
        switch self {
        case .allPhotos:
            Label("보관함", systemImage: "photo")
        case .albums:
            Label("앨범", systemImage: "square.stack.fill")
        }
    }
    
    var navigationTitle: String {
        switch self {
        case .allPhotos: ""
        case .albums: "앨범"
        }
    }
    
    var navigationBarTitleDisplayMode: NavigationBarItem.TitleDisplayMode {
        switch self {
        case .allPhotos: return .automatic
        case .albums: return .inline
        }
    }
}
