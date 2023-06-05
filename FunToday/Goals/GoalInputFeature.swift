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
    var id: String {
      goal.id
    }
    var routines: IdentifiedArrayOf<RoutineInputFeature.State>
    var isNew: Bool = false
  }
  
  enum Action {
    case addGoal
    case removeGoal
    case saveGoal
    case addRoutine
    case resetGoal
    case setFold
    case updateName(String)
    case updateDescription(String)
    case routineElement(id: RoutineInputFeature.State.ID, action: RoutineInputFeature.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .addRoutine:
        let routine = Routine.getDouble()
        state.routines.append(RoutineInputFeature.State(routine: routine))
        state.goal.routines.append(routine)
        return .none
      case .resetGoal:
        state.goal = Goal.getDouble()
        state.routines = []
        return .none
      case .setFold:
        state.goal.isFold.toggle()
        return .none
      case .updateName(let txt):
        state.goal.name = txt
        return .none
      case .updateDescription(let txt):
        state.goal.description = txt
        return .none
      case .routineElement(id: let id, action: .removeRoutine):
        guard
          let removed = state.routines.remove(id: id),
          let inx = state.goal.routines.firstIndex(of: removed.routine)
        else {
          return .none
        }
        
        state.goal.routines.remove(at: inx)
        return .none
      case .addGoal, .removeGoal, .saveGoal, .routineElement:
        return .none
      }
    }.forEach(\State.routines, action: /Action.routineElement(id:action:)) {
      RoutineInputFeature()
    }
  }
}
