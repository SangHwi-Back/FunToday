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
    
    case fromRoutineElement(id: RoutineInputFeature.State.ID, action: RoutineInputFeature.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .removeGoal:
        return .none
      case .saveGoal:
        state.goal.routines = state.routines.elements.map({$0.routine})
        return .none
      case .addRoutine:
        let routine = Routine.getDouble()
        state.routines.append(.init(routine: routine, isNew: state.isNew))
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
      case .fromRoutineElement(id: let id, action: .removeRoutine):
        state.routines.remove(id: id)
        return .run { await $0(.saveGoal) }
      case .addGoal, .fromRoutineElement:
        return .run { await $0(.saveGoal) }
      }
    }
    .forEach(\.routines, action: /Action.fromRoutineElement(id:action:)) {
      RoutineInputFeature()
    }
  }
}
