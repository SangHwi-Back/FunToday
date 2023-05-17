//
//  FunTodayApp.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI

@main
struct FunTodayApp: App {

  @ObservedObject var firebasedb = DependencyFirebaseDB()

  var body: some Scene {
    WindowGroup {
      FunTodayAppTabView()
        .environmentObject(firebasedb)
    }
  }
}
