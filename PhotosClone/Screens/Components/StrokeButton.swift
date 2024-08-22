//
//  StrokeButton.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/23/24.
//

import SwiftUI

struct StrokedButton<Content: View, ClipShape: Shape>: View {
    private let clipShape: ClipShape
    private let edge: Edge.Set
    private let length: CGFloat
    private let content: () -> Content
    private let action: () -> Void
    
    init(
        _ shape: ClipShape,
        _ padding: Edge.Set = .all,
        _ length: CGFloat = 10,
        content: @escaping () -> Content,
        action: @escaping () -> Void
    ) {
        self.clipShape = shape
        self.edge = padding
        self.length = length
        self.content = content
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            content()
                .font(.headline)
                .padding(edge, length)
                .background(.white)
                .overlay(
                    clipShape
                        .stroke(Color.accentColor, lineWidth: 4)
                )
                .clipShape(clipShape)
                .shadow(color: .secondary, radius: 4, y: 4)
        }
    }
}
