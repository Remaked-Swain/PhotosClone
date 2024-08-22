//
//  MainView.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/20/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var libraryService: LibraryService
    @State private var isAlertPresented: Bool = false
    
    var body: some View {
        VStack {
            AllPhotosView(assets: libraryService.assets)
        }
        .task {
            do {
                try await libraryService.requestAuthorizationIfNeeded()
            } catch {
                isAlertPresented.toggle()
            }
        }
        .alert("사진 앱 사용 불가", isPresented: $isAlertPresented) {
            // TODO: 추가로 수행해야 할 작업 있으면 이곳에 작성
        } message: {
            Text("설정 앱으로 이동하여 사진 라이브러리로의 접근 권한을 설정해주세요.")
        }
    }
}

#Preview {
    MainView()
        .environmentObject(LibraryService())
}
