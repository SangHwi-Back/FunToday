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
    case setList, itemAdded
    
    case fromActivityNewItem(action:ActivityInputFeature.Action)
    case fromActivityItems(id:ActivityInputFeature.State.ID,action:ActivityInputFeature.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.newActivity, action: /Action.fromActivityNewItem(action:)) {
      ActivityInputFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .setList:
        let activities = ActivityStore.DP.loadAll()
          .compactMap({
            try? JSONDecoder().decode(Activity.self, from: $0)
          })
        var result = IdentifiedArrayOf<ActivityInputFeature.State>.init()
        for activity in activities {
          result.append(ActivityInputFeature.State(activity: activity))
        }
        
        state.activities = result
        return .none
      case .fromActivityNewItem(action: .addActivity):
        if let data = try? JSONEncoder().encode(state.newActivity.activity) {
          
          ActivityStore.DP.save(data: data)
          
          state.activities.append(state.newActivity)
          state.newActivity = .init(activity: Activity.getDouble())
        }
        
        state.newActivity = .init(activity: Activity.getDouble())
        return .none
      case .fromActivityItems(id: let id, action: .removeActivity):
        state.activities.remove(id: id)
        ActivityStore.DP.overwrite(data: state
          .activities
          .map({ $0.activity })
          .compactMap({ try? JSONEncoder().encode($0) })
        )
        
        return .none
      case .fromActivityNewItem, .fromActivityItems, .itemAdded:
        return .none
      }
    }
    .forEach(\.activities, action: /Action.fromActivityItems(id:action:)) {
      ActivityInputFeature()
    }
  }
}
