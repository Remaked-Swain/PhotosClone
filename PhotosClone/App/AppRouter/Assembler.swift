//
//  Assembler.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/23/24.
//

import Foundation

protocol Assembly {
    func assemble(container: DependencyContainer)
    func loaded(resolver: DependencyResolver)
}

struct CommonAssembly: Assembly {
    func assemble(container: any DependencyContainer) {
        container.register(for: LibraryService.self, LibraryService())
        container.register(for: MainViewModel.self) { resolver in
            MainViewModel(libraryService: resolver.resolve(LibraryService.self))
        }
        container.register(for: AllPhotosViewModel.self) { resolver in
            AllPhotosViewModel(libraryService: resolver.resolve(LibraryService.self))
        }
        container.register(for: ThumbnailViewModel.self) { resolver in
            ThumbnailViewModel(libraryService: resolver.resolve(LibraryService.self))
        }
        container.register(for: VideoPlayerViewModel.self) { resolver in
            VideoPlayerViewModel(libraryService: resolver.resolve(LibraryService.self))
        }
        container.register(for: AssetDisplayViewModel.self) { resolver in
            AssetDisplayViewModel(libraryService: resolver.resolve(LibraryService.self))
        }
        container.register(for: AssetCollectionViewModel.self) { resolver in
            AssetCollectionViewModel(libraryService: resolver.resolve(LibraryService.self))
        }
    }
    
    func loaded(resolver: any DependencyResolver) {
        //
    }
}

final class Assembler {
    private let container: DependencyContainer
    
    var resolver: DependencyResolver { container }
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    init(
        container: DependencyContainer = DefaultDependencyContainer(),
        by assemblies: [Assembly]
    ) {
        self.container = container
        run(assemblies: assemblies)
    }
    
    private func run(assemblies: [Assembly]) {
        for assembly in assemblies {
            assembly.assemble(container: container)
        }
        
        for assembly in assemblies {
            assembly.loaded(resolver: resolver)
        }
    }
    
    func apply(assemblies: Assembly...) {
        run(assemblies: assemblies)
    }
    
    func apply(assembly: Assembly) {
        run(assemblies: [assembly])
    }
}
