//
//  GoalsViewFeature.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/17.
//

import Foundation
import ComposableArchitecture

struct GoalListFeature: ReducerProtocol {
  struct State: Equatable {
    var list: IdentifiedArrayOf<GoalFeature.State> = []
  }
  
  enum Action: Equatable {
    case requestGoals
    case setGoal(Goal)
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .requestGoals:
      state.list.insert(
        GoalFeature.State(goal: Goal.getDouble()),
        at: 0
      )
      return .none
    case .setGoal(let goal):
      
      for i in 0..<state.list.count {
        if state.list[i].goal == goal {
          state.list[i].goal = goal
          break
        }
      }
      
      return .none
    }
  }
}
