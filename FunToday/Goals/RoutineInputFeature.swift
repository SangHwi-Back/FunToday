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
    var containerState = ActivityContainerFeature.State(activities: .init())
  }
  
  enum Action {
    case updateName(String)
    case updateDescription(String)
    case removeRoutine
    
    case activityElements(id: ActivityInputFeature.State.ID, action: ActivityInputFeature.Action)
    case activityContainerElement(action: ActivityContainerFeature.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.containerState, action: /Action.activityContainerElement(action:)) {
      ActivityContainerFeature()
    }
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
      case .activityElements:
        return .none
      case .activityContainerElement(action: .addActivity):
        state.containerState.activities.append(.init(activity: Activity.getDouble()))
        return .none
      case .activityContainerElement:
        return .none
      }
    }.forEach(\.containerState.activities, action: /Action.activityElements(id:action:)) {
      ActivityInputFeature()
    }
  }
}
