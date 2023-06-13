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
    var id: UUID = .init()
    var activities: IdentifiedArrayOf<ActivityInputFeature.State>
    var presetActivity: ActivityPresetListFeature.State
  }
  
  enum Action {
    case addActivity
    case saveContainer
    
    case fromActivityElements(id: ActivityInputFeature.State.ID, action: ActivityInputFeature.Action)
    case fromPresetElements(action:ActivityPresetListFeature.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.presetActivity, action: /Action.fromPresetElements(action:)) {
      ActivityPresetListFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .fromActivityElements(id: let id, action: .removeActivity):
        state.activities.remove(id: id)
        return .none
      case .fromPresetElements(action: .rowSelected(let activity)):
        state.activities.append(
          ActivityInputFeature.State(activity: activity)
        )
        
        return .none
      case .addActivity, .saveContainer, .fromActivityElements, .fromPresetElements:
        return .none
      }
    }.forEach(\.activities, action: /Action.fromActivityElements(id:action:)) {
      ActivityInputFeature()
    }
  }
  
  // MARK: - Inner State
  enum ActivityHeaderButtonType {
    case basic, minus
  }
}
