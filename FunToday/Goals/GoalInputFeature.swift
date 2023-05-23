//
//  GoalInputFeature.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/22.
//

import Foundation
import ComposableArchitecture

struct GoalInputFeature: ReducerProtocol {
  struct State: Equatable, Identifiable {
    var goal: Goal
    var id: UUID = .init()
    var routines: IdentifiedArrayOf<RoutineInputFeature.State>
  }
  
  enum Action {
    case addGoal
    case addRoutine
    case resetGoal
    case updateName(String)
    case updateDescription(String)
    case routineElement(id: RoutineInputFeature.State.ID, action: RoutineInputFeature.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .addGoal:
        return .none
      case .addRoutine:
        state.routines.append(
          RoutineInputFeature.State(routine: Routine.getDouble(), activities: .init())
        )
        return .none
      case .resetGoal:
        state.goal = Goal.getDouble()
        state.routines = []
        return .none
      case .updateName(let txt):
        state.goal.name = txt
        return .none
      case .updateDescription(let txt):
        state.goal.description = txt
        return .none
      case .routineElement(id: let id, action: .removeRoutine):
        state.routines.remove(id: id)
        return .none
      case .routineElement:
        return .none
      }
    }.forEach(\State.routines, action: /Action.routineElement(id:action:)) {
      RoutineInputFeature()
    }
  }
}
