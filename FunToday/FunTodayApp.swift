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
  @State var loginConfirmed = false
  
  var body: some Scene {
    WindowGroup {
      if loginConfirmed {
        FunTodayAppTabView()
          .environmentObject(firebasedb)
      } else {
        LoginView(store: Store(
          initialState: .init(),
          reducer: { LoginFeature(loginConfirmed: $loginConfirmed) }))
      }
    }
  }
}
