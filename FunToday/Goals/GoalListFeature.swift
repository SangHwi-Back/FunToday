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
    var goalList: IdentifiedArrayOf<GoalItemFeature.State>
  }
  
  enum Action {
    case setGoal(Goal)
    case sortGoal
    case goalItem(id: GoalItemFeature.State.ID, action: GoalItemFeature.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .setGoal(let goal):
        guard state.goalList.contains(where: {$0.goal == goal}) else {
          return .none
        }
        
        for i in 0..<state.goalList.count {
          if state.goalList[i].goal == goal {
            state.goalList[i].goal = goal
            break
          }
        }
        
        return .none
        
      case .sortGoal:
        state.goalList.sort { $0.id == $1.id }
        return .none
        
      case .goalItem(id: _, action: .setFold):
        return .none
        
      case .goalItem:
        return .none
      }
    }
    .forEach(\State.goalList , action: /Action.goalItem(id:action:)) {
      GoalItemFeature()
    }
  }
}
