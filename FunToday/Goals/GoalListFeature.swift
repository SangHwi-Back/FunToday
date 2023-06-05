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
    case goalItem(id: GoalItemFeature.State.ID, action: GoalItemFeature.Action)
    case inputNewItem(action: GoalInputFeature.Action)
    case inputItems(id: GoalInputFeature.State.ID, action: GoalInputFeature.Action)
    case setList
  }
  
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.newGoal, action: /Action.inputNewItem(action:)) {
      GoalInputFeature()
    }
    Reduce { state, action in
      switch action {
      case .goalItem(id: _, action: .setGoal(let goal)):
        guard let inx = state.goalList.firstIndex(where: { $0.goal.id == goal.id }) else {
          return .none
        }
        
        state.goalList[inx].goal = goal
        
        return .none
      case .inputNewItem(action: .addGoal):
        state.goalList.append(state.newGoal)
        
        if let data = try? JSONEncoder().encode(state.newGoal.goal) {
          GoalStore.DP.save(data: data)
        }
        
        state.newGoal = .init(goal: .getDouble(), routines: .init(), isNew: true)
        return .none
      case .setList:
        let goals = GoalStore.DP.loadAll()
          .compactMap({
            try? JSONDecoder().decode(Goal.self, from: $0)
          })
        var result = IdentifiedArrayOf<GoalInputFeature.State>()
        for goal in goals {
          var routineResult = IdentifiedArrayOf<RoutineInputFeature.State>()
          
          for routine in goal.routines {
            routineResult.append(RoutineInputFeature.State(routine: routine))
          }
          
          result.append(GoalInputFeature.State(goal: goal, routines: routineResult))
        }
        
        state.goalList = result
        return .none
      case .goalItem, .inputItems, .inputNewItem:
        return .none
      }
    }
    .forEach(\.goalList, action: /Action.inputItems(id:action:)) {
      GoalInputFeature()
    }
  }
}
