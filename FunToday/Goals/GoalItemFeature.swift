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
    var isFold: Bool = true
    let id: UUID
  }
  
  enum Action {
    case addGoal(Goal)
    case setGoal(Goal)
    case setFold
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .addGoal(let goal):
      return .none
    case .setGoal(let goal):
      return .none
    case .setFold:
      state.isFold.toggle()
      return .none
    }
  }
}
