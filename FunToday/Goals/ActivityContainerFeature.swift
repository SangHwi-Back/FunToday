//
//  ActivityContainerFeature.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/22.
//

import Foundation
import ComposableArchitecture

struct ActivityContainerFeature: ReducerProtocol {
  struct State: Equatable, Identifiable {
    static func == (lhs: ActivityContainerFeature.State, rhs: ActivityContainerFeature.State) -> Bool {
      lhs.id == rhs.id
    }
    var id: UUID = .init()
    var activities: IdentifiedArrayOf<ActivityInputFeature.State>
    var presetActivity: ActivityContainerPresetListFeature.State
  }
  
  enum Action {
    case addActivity
    case removeActivity
    case activityElement(id: ActivityInputFeature.State.ID, action: ActivityInputFeature.Action)
    case presetElement(action:ActivityContainerPresetListFeature.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.presetActivity, action: /Action.presetElement(action:)) {
      ActivityContainerPresetListFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .addActivity:
        return .none
      case .removeActivity:
        return .none
      case .activityElement(id: let id, action: .removeActivity):
        state.activities.remove(id: id)
        return .none
      case .presetElement(action: .rowSelected(let activity)):
        state.activities.append(
          ActivityInputFeature.State(activity: activity)
        )
        
        return .none
      case .activityElement, .presetElement:
        return .none
      }
    }.forEach(\.activities, action: /Action.activityElement(id:action:)) {
      ActivityInputFeature()
    }
  }
  
  // MARK: - Inner State
  enum ActivityHeaderButtonType {
    case basic, minus
  }
}
