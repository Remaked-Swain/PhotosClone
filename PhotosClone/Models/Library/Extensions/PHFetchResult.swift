//
//  PHFetchResult.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/22/24.
//

import Foundation
import Photos

extension PHFetchResult<PHAsset> {
    /// PHFetchResult의 객체를 배열화
    func toArray() -> [PHAsset] {
        let start: Int = .zero
        let end: Int = self.count
        return self.objects(at: IndexSet(integersIn: start..<end))
    }
}
