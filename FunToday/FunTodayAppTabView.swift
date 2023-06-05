//
//  ContentView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI
import ComposableArchitecture

struct FunTodayAppTabView: View {
  var body: some View {
    TabView {
      NavigationView {
        GoalListView(store: Store(
          initialState: GoalListFeature.State(goalList: .init()),
          reducer: {
            GoalListFeature()
          }
        ))
      }
      .navigationViewStyle(StackNavigationViewStyle())
      .tabItem {
        FunTodayTab.goal.getLabel()
      }
      
      NavigationView {
        ReviewView()
      }
      .navigationViewStyle(StackNavigationViewStyle())
      .tabItem {
        FunTodayTab.review.getLabel()
      }
      
      NavigationView {
        SettingView()
      }
      .navigationViewStyle(StackNavigationViewStyle())
      .tabItem {
        FunTodayTab.setting.getLabel()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    FunTodayAppTabView()
  }
}
