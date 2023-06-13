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
    var goalList: IdentifiedArrayOf<GoalInputFeature.State>
    var newGoal: GoalInputFeature.State = .init(goal: .getDouble(), routines: .init(), isNew: true)
  }
  
  enum Action {
    case setList
    
    case fromNewItem(action: GoalInputFeature.Action)
    case fromItems(id: GoalInputFeature.State.ID, action: GoalInputFeature.Action)
  }
  
  func getGoalListFromStore() -> IdentifiedArrayOf<GoalInputFeature.State> {
    let goals = GoalStore.DP.loadAll().compactMap {
      try? JSONDecoder().decode(Goal.self, from: $0)
    }
    
    return IdentifiedArrayOf<GoalInputFeature.State>(
      uniqueElements: goals.map({$0.toState()})
    )
  }
  
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.newGoal, action: /Action.fromNewItem(action:)) {
      GoalInputFeature()
    }
    Reduce { state, action in
      switch action {
      case .fromNewItem(action: .addGoal):
        state.goalList.append(state.newGoal)
        
        if let data = try? JSONEncoder().encode(state.newGoal.goal) {
          GoalStore.DP.save(data: data)
        }
        
        state.newGoal = .init(goal: .getDouble(), routines: .init(), isNew: true)
        return .none
      case .fromItems(id: let id, action: .removeGoal):
        guard
          let removed = state.goalList.remove(id: id)?.goal,
          let data = try? JSONEncoder().encode(removed)
        else {
          return .none
        }
        
        GoalStore.DP.remove(data: data)
        
        return .none
      case .fromItems(id: _, action: .saveGoal):
        let data = state.goalList.elements
          .map({$0.goal})
          .compactMap {
            try? JSONEncoder().encode($0)
          }
        GoalStore.DP.overwrite(data: data)
        
        return .none
      case .setList:
        state.goalList = getGoalListFromStore()
        return .none
      case .fromItems, .fromNewItem:
        return .none
      }
    }
    .forEach(\.goalList, action: /Action.fromItems(id:action:)) {
      GoalInputFeature()
    }
  }
}
