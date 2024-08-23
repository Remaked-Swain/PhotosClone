//
//  MainView.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/20/24.
//

import SwiftUI

struct MainView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: MainViewModel
    
    init(_ viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            router.view(to: .allPhotosView)
        }
        .task {
            do {
                try await viewModel.requestAuthorizationIfNeeded()
            } catch {
                viewModel.isAlertPresented.toggle()
            }
        }
        .alert("사진 앱 사용 불가", isPresented: $viewModel.isAlertPresented) {
            Text("확인")
        } message: {
            Text("설정 앱으로 이동하여 사진 라이브러리로의 접근 권한을 설정해주세요.")
        }
    }
}

#Preview {
    MainView<DefaultAppRouter>(MainViewModel(libraryService: LibraryService()))
        .environmentObject(DefaultAppRouter(by: CommonAssembly()))
}
