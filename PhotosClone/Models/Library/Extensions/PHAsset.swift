//
//  PHAsset.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/22/24.
//

import Foundation
import Photos

extension PHAsset: Identifiable {
    public var id: String { self.localIdentifier }
}
