//
//  GoalItemFeature.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/17.
//

import Foundation
import ComposableArchitecture

struct GoalItemFeature: ReducerProtocol {
  struct State: Equatable, Identifiable {
    var goal: Goal
    let id: UUID
  }
  
  enum Action {
    case setFold
    case setRoutine(Routine)
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .setFold:
      state.goal.isFold.toggle()
      return .none
    case .setRoutine(let routine):
      for i in 0..<state.goal.routines.count {
        if state.goal.routines[i] == routine {
          state.goal.routines[i] = routine
        }
      }
      return .none
    }
  }
}
