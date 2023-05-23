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
    var newGoal: GoalInputFeature.State = .init(goal: .getDouble(), routines: .init())
  }
  
  enum Action {
    case goalItem(id: GoalItemFeature.State.ID, action: GoalItemFeature.Action)
    case inputItem(action: GoalInputFeature.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .goalItem(id: _, action: .setGoal(let goal)):
        guard let inx = state.goalList.firstIndex(where: { $0.goal.id == goal.id }) else {
          return .none
        }
        
        state.goalList[inx].goal = goal
        
        return .none
      case .inputItem(action: .addGoal):
        state.goalList.append(GoalItemFeature.State.init(goal: state.newGoal.goal, id: .init()))
        state.newGoal = .init(goal: .getDouble(), routines: .init())
        return .none
      case .goalItem:
        return .none
      case .inputItem:
        return .none
      }
    }
    .forEach(\State.goalList , action: /Action.goalItem(id:action:)) {
      GoalItemFeature()
    }
  }
}
