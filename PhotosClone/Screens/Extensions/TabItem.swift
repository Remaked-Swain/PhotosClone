//
//  TabItem.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/24/24.
//

import SwiftUI

struct TabItemStyle: ViewModifier {
    let type: ScreenType
    
    func body(content: Content) -> some View {
        content
            .tabItem { type.label }
            .tag(type)
    }
}

extension View {
    func tabItemStyle(_ type: ScreenType) -> some View {
        self.modifier(TabItemStyle(type: type))
    }
}
