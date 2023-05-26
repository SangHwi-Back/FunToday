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

struct SettingActivityPresetFeature: ReducerProtocol {
  struct State: Equatable {
    var activities: IdentifiedArrayOf<ActivityInputFeature.State>
    var newActivity: ActivityInputFeature.State
  }
  enum Action {
    case activityNewItem(action:ActivityInputFeature.Action)
    case activityItems(id:ActivityInputFeature.State.ID,action:ActivityInputFeature.Action)
    case setList
  }
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.newActivity, action: /Action.activityNewItem(action:)) {
      ActivityInputFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .activityNewItem(action: .buttonTapped):
        state.activities.append(state.newActivity)
        
        if let saved = UserDefaults.standard.object(forKey: "Activities") as? [Data] {
          
          var activities = saved.compactMap({
            try? JSONDecoder().decode(Activity.self, from: $0)
          })
          activities.append(state.newActivity.activity)
          
          let newSaved = activities.compactMap({
            try? JSONEncoder().encode($0)
          })
          
          UserDefaults.standard.set(newSaved, forKey: "Activities")
        }
        else {
          if let data = try? JSONEncoder().encode(state.newActivity.activity) {
            UserDefaults.standard.set([data], forKey: "Activities")
          }
        }
        
        state.newActivity = .init(activity: Activity.getDouble())
        return .none
      case .activityNewItem, .activityItems:
        return .none
      case .setList:
        let saved = (UserDefaults.standard.object(forKey: "Activities") as? [Data]) ?? []
        let activities = saved.compactMap({
          try? JSONDecoder().decode(Activity.self, from: $0)
        })
        var result = IdentifiedArrayOf<ActivityInputFeature.State>.init()
        for activity in activities {
          result.append(ActivityInputFeature.State(activity: activity))
        }
        
        state.activities = result
        return .none
      }
    }
    .forEach(\.activities, action: /Action.activityItems(id:action:)) {
      ActivityInputFeature()
    }
  }
}
