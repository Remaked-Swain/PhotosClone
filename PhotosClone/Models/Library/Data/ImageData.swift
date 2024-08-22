//
//  ImageData.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/22/24.
//

import UIKit
import Photos

struct ImageData {
    let requestId: PHImageRequestID?
    let image: UIImage
    let isLowerQuality: Bool
}
