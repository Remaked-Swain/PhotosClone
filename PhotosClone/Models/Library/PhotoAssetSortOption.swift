//
//  PhotoAssetSortOption.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/20/24.
//

import Foundation

enum PhotoAssetSortOption {
    case creationDate
    case modificationDate
    
    var key: String {
        switch self {
        case .creationDate: "creationDate"
        case .modificationDate: "modificationDate"
        }
    }
    
    func sortDescriptor(_ isOrderedByAscending: Bool) -> NSSortDescriptor {
        .init(key: key, ascending: isOrderedByAscending)
    }
}
