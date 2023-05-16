//
//  ContentView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI

struct FunTodayAppTabView: View {
  @ObservedObject var firebasedb = DependencyFirebaseDB()
  @State var selectedTab = FunTodayTab.goal
  
  var body: some View {
    TabView(selection: $selectedTab) {
      GoalsView()
        .tabItem {
          FunTodayTab.goal.getLabel()
        }
      
      ReviewView()
        .tabItem {
          FunTodayTab.review.getLabel()
        }
      
      SettingView()
        .tabItem {
          FunTodayTab.setting.getLabel()
        }
    }
    .environmentObject(firebasedb)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    FunTodayAppTabView()
  }
}
