//
//  FunTodayApp.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI
import ComposableArchitecture

@main
struct FunTodayApp: App {

  @ObservedObject var firebasedb = DependencyFirebaseDB()
  var isLogin = false
  
  var body: some Scene {
    WindowGroup {
      if isLogin {
        FunTodayAppTabView()
          .environmentObject(firebasedb)
      } else {
        LoginView(store: Store(initialState: .init(), reducer: { LoginFeature() }))
      }
    }
  }
}
