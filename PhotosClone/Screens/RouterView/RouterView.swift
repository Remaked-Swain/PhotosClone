//
//  RouterView.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/23/24.
//

import SwiftUI

struct RouterView<Router: AppRouter>: View {
    @StateObject private var router: Router
    private let root: Router.Destination
    
    init(router: Router, root: Router.Destination) {
        self._router = StateObject(wrappedValue: router)
        self.root = root
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            router.view(to: root)
                .navigationDestination(for: Router.Destination.self) { destination in
                    router.view(to: destination)
                }
        }
    }
}
