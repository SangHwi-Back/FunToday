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
    
    var isNew: Bool = false
    var currentIndex: ActivityInputFeature.State.ID = ""
    var routineDateTitle: String = "" {
      didSet {
        for i in activities.indices {
          activities[i].routineDateTitle = routineDateTitle
        }
      }
    }
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
        state.activities = IdentifiedArray(uniqueElements:
          state.activities.sorted(by: {
            $0.activity.startDate < $1.activity.startDate
          })
        )
        return .none
      case .fromPresetElements(action: .rowSelected(let activity)):
        var newState = ActivityInputFeature.State(activity: activity)
        newState.isNew = state.isNew
        state.activities.append(newState)
        
        return .none
      case .addActivity, .saveContainer, .fromActivityElements, .fromPresetElements:
        return .none
      }
    }.forEach(\.activities, action: /Action.fromActivityElements(id:action:)) {
      ActivityInputFeature()
    }
  }
}
