//
//  AppRouter.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/23/24.
//

import SwiftUI

protocol AppRouter: ObservableObject {
    associatedtype Destination: Routable where Destination == Route
    associatedtype Content: View
    
    var path: NavigationPath { get set }
    var assembler: Assembler { get }
    var resolver: DependencyResolver { get }
    
    @ViewBuilder func view(to destination: Destination) -> Content
    func route(to destination: Destination)
    func dismiss()
    func popToRoot()
}

extension AppRouter {
    var resolver: DependencyResolver { assembler.resolver }
}

final class DefaultAppRouter: AppRouter {
    typealias Destination = Route
    
    @Published var path: NavigationPath
    
    let assembler: Assembler
    
    init(
        path: NavigationPath = NavigationPath(),
        assembler: Assembler
    ) {
        self.path = path
        self.assembler = assembler
    }
    
    convenience init(
        by assemblies: Assembly...
    ) {
        let assembler = Assembler(by: assemblies)
        self.init(assembler: assembler)
    }
    
    private func _push(_ destination: Destination) {
        path.append(destination)
    }
    
    @ViewBuilder func view(to destination: Destination) -> some View {
        destination.view(with: self)
            .environmentObject(self)
    }
    
    func route(to destination: Destination) {
        switch destination.presentingType {
        case .push:
            _push(destination)
        }
    }
    
    func dismiss() {
        if path.isEmpty == false {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        if path.isEmpty == false {
            path.removeLast(path.count)
        }
    }
}
