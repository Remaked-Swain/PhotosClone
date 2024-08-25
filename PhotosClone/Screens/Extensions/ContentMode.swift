//
//  ContentMode.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/24/24.
//

import SwiftUI
import Photos

extension ContentMode {
    var asImageContentMode: PHImageContentMode {
        switch self {
        case .fit:
                .aspectFit
        case .fill:
                .aspectFill
        }
    }
}
