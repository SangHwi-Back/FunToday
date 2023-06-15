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
    var currentIndex: ActivityInputFeature.State.ID = ""
    var activities: IdentifiedArrayOf<ActivityInputFeature.State>
    var presetActivity: ActivityPresetListFeature.State
  }
  
  enum Action {
    case addActivity
    case saveContainer
    case setIndex(ActivityInputFeature.State.ID)
    case buttonTapped(ActivityInputFeature.State.ID)
    
    case fromActivityElements(id: ActivityInputFeature.State.ID, action: ActivityInputFeature.Action)
    case fromPresetElements(action:ActivityPresetListFeature.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.presetActivity, action: /Action.fromPresetElements(action:)) {
      ActivityPresetListFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .setIndex(let id), .buttonTapped(id: let id):
        state.currentIndex = id
        return .none
      case .fromActivityElements(id: let id, action: .removeActivity):
        state.activities.remove(id: id)
        return .none
      case .fromActivityElements(id: _, action: .updateDate):
        print(state.activities.map({$0.activity.name}))
        state.activities = IdentifiedArray(uniqueElements:
          state.activities.sorted(by: {
            $0.activity.startDate < $1.activity.startDate
          })
        )
        print(state.activities.map({$0.activity.name}))
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
}
