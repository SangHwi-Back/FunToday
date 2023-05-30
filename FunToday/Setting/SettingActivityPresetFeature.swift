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
    case setList, itemAdded
  }
  
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.newActivity, action: /Action.activityNewItem(action:)) {
      ActivityInputFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .activityNewItem(action: .addActivity):
        if let data = try? JSONEncoder().encode(state.newActivity.activity) {
          
          MemoryStore.DP.save(data: MemoryStore.DP.loadAll() + [data])
          
          state.activities.append(state.newActivity)
          state.newActivity = .init(activity: Activity.getDouble())
        }
        
        state.newActivity = .init(activity: Activity.getDouble())
        return .none
      case .activityItems(id: let id, action: .removeActivity):
        state.activities.remove(id: id)
        MemoryStore.DP.save(data: state
          .activities
          .map({ $0.activity })
          .compactMap({ try? JSONEncoder().encode($0) })
        )
        
        return .none
      case .setList:
        let activities = MemoryStore.DP.loadAll()
          .compactMap({
            try? JSONDecoder().decode(Activity.self, from: $0)
          })
        var result = IdentifiedArrayOf<ActivityInputFeature.State>.init()
        for activity in activities {
          result.append(ActivityInputFeature.State(activity: activity))
        }
        
        state.activities = result
        return .none
      case .activityNewItem, .activityItems, .itemAdded:
        return .none
      }
    }
    .forEach(\.activities, action: /Action.activityItems(id:action:)) {
      ActivityInputFeature()
    }
  }
}
