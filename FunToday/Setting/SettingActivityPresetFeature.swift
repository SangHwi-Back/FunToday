//
//  SettingActivityPresetFeature.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/26.
//

import Foundation
import ComposableArchitecture

struct SettingActivityPresetFeature: ReducerProtocol {
  struct State: Equatable {
    var activities: IdentifiedArrayOf<ActivityInputFeature.State>
    var newActivity: ActivityInputFeature.State
  }
  enum Action {
    case activityNewItem(action:ActivityInputFeature.Action)
    case activityItems(id:ActivityInputFeature.State.ID,action:ActivityInputFeature.Action)
    case setList
    case itemAdded
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
      case .activityItems(id: let id, action: .removeActivity):
        if
          let removed = state.activities.remove(id: id),
          let saved = UserDefaults.standard.object(forKey: "Activities") as? [Data] {
          
          var activities = saved.compactMap({
            try? JSONDecoder().decode(Activity.self, from: $0)
          })
          
          for (index, activity) in activities.enumerated() {
            if activity.id == removed.activity.id {
              activities.remove(at: index)
              break
            }
          }
          
          let newSaved = activities.compactMap({
            try? JSONEncoder().encode($0)
          })
          
          UserDefaults.standard.set(newSaved, forKey: "Activities")
        }
        
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
      case .itemAdded:
        return .none
      }
    }
    .forEach(\.activities, action: /Action.activityItems(id:action:)) {
      ActivityInputFeature()
    }
  }
}
