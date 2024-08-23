//
//  SmallMaterialButton.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/23/24.
//

import SwiftUI

extension Image {
    @ViewBuilder func smallMaterialButton() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: 20)
            .padding(10)
            .background(.ultraThickMaterial)
            .clipShape(.capsule)
    }
}
