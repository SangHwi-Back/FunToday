//
//  SettingActivityPresetView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/25.
//

import SwiftUI
import ComposableArchitecture

struct SettingActivityPresetView: View {
  let store: StoreOf<SettingActivityPresetFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewstore in
      ZStack(alignment: .bottomTrailing) {
        ScrollView {
          VStack(spacing: 4) {
            ForEachStore(
              store.scope(state: \.activities, action: SettingActivityPresetFeature.Action.activityItems(id:action:))
            ) {
              let store = $0
              NavigationLink {
                ActivityInputView(store: store)
              } label: {
                SettingActivityPresetRowContent(store: store)
              }
            }
          }
        }
        
        NavigationLink {
          ActivityInputView(
            store: store.scope(
              state: \.newActivity,
              action: SettingActivityPresetFeature.Action.activityNewItem(action:)),
            isSetting: true
          )
          .padding()
        } label: {
          FloatingPlusButton(width: 54)
        }
      }
      .onAppear {
        viewstore.send(.setList)
      }
    }
  }
}

struct DecisionButton: View {
  var action: () -> Void
  var title: String
  
  var body: some View {
    Button { action() } label: {
      ZStack {
        CommonRectangle(color: Binding.constant(Color.gray.opacity(0.7)))
        Text(title)
          .foregroundColor(.white)
          .bold()
          .padding()
      }
      .fixedSize(horizontal: true, vertical: false)
      .frame(height: 50)
    }
  }
}

private struct SettingActivityPresetRowContent: View {
  let store: StoreOf<ActivityInputFeature>
  
  var body: some View {
    WithViewStore(store) { viewstore in
      Text(viewstore.activity.name)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
  }
}
