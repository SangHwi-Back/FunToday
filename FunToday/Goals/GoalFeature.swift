//
//  GoalFeature.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/17.
//

import Foundation
import ComposableArchitecture

struct GoalFeature: ReducerProtocol {
  struct State: Equatable, Identifiable {
    var goal: Goal
    var id: String {
      goal.id
    }
  }
  
  enum Action {
    case setFold(Bool)
    case setRoutine(Routine)
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .setFold(let fold):
      state.goal.isFold = fold
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
