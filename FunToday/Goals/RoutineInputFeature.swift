//
//  RoutineInputFeature.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/22.
//

import Foundation
import ComposableArchitecture

struct RoutineInputFeature: ReducerProtocol {
  struct State: Equatable, Identifiable {
    var id: UUID = .init()
    var routine: Routine
    var activities: IdentifiedArrayOf<ActivityContainerFeature.State>
  }
  
  enum Action {
    case updateName(String)
    case updateDescription(String)
    case removeRoutine
    case activityContainerElement(id:ActivityContainerFeature.State.ID, action: ActivityContainerFeature.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .updateName(let txt):
        state.routine.name = txt
        return .none
      case .updateDescription(let txt):
        state.routine.description = txt
        return .none
      case .removeRoutine:
        return .none
      case .activityContainerElement(id: let id, action: .removeActivity):
        state.activities.remove(id: id)
        return .none
      case .activityContainerElement:
        return .none
      }
    }.forEach(\.activities, action: /Action.activityContainerElement(id:action:)) {
      ActivityContainerFeature()
    }
  }
}
