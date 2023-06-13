//
//  RoutineInputFeature.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/22.
//

import Foundation
import ComposableArchitecture

struct RoutineInputFeature: ReducerProtocol {
  struct State: Equatable, Identifiable {
    var id: String {
      routine.id
    }
    var routine: Routine
    var containerState = ActivityContainerFeature.State(
      activities: .init(),
      presetActivity: .init(list: []))
    
    init(routine: Routine) {
      self.routine = routine
      self.containerState = ActivityContainerFeature.State(
        activities: IdentifiedArrayOf(uniqueElements: routine.activities.map({ActivityInputFeature.State(activity: $0)})),
        presetActivity: .init(list: []))
    }
  }
  
  enum Action {
    case updateName(String)
    case updateDescription(String)
    case removeRoutine
    
    case fromActivityElements(id: ActivityInputFeature.State.ID, action: ActivityInputFeature.Action)
    case fromActivityContainerElements(action: ActivityContainerFeature.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.containerState, action: /Action.fromActivityContainerElements(action:)) {
      ActivityContainerFeature()
    }
    Reduce { state, action in
      switch action {
      case .updateName(let txt):
        state.routine.name = txt
        return .none
        
      case .updateDescription(let txt):
        state.routine.description = txt
        return .none
        
      case .fromActivityElements(id: let id, action: .removeActivity):
        guard
          let removed = state.containerState.activities.remove(id: id),
          let inx = state.routine.activities.firstIndex(of: removed.activity)
        else {
          return .none
        }
        
        state.routine.activities.remove(at: inx)
        return .none
        
      case .fromActivityElements(id: let id, action: _):
        guard let inx = state.containerState.activities.firstIndex(where: { $0.id == id }) else {
          return .none
        }
        
        let activity = state.containerState.activities[inx].activity
        state.routine.activities[inx] = activity
        return .none
      
      case .fromActivityContainerElements(action: .addActivity):
        let activity = Activity.getDouble()
        state.containerState.activities.append(.init(activity: activity))
        state.routine.activities.append(activity)
        
        return .none
        
      case .fromActivityContainerElements:
        state.routine.activities = state.containerState.activities.elements.map({$0.activity})
        return .none
        
      case .removeRoutine:
        return .none
      }
    }.forEach(\.containerState.activities, action: /Action.fromActivityElements(id:action:)) {
      ActivityInputFeature()
    }
  }
}

//extension RoutineInputFeature.Action: Equatable {
//  typealias Action = RoutineInputFeature.Action
//  static func == (lhs: Action, rhs: Action) -> Bool {
//    switch (lhs, rhs) {
//    case (.updateName(let leftText), .updateName(let rightText)):
//      return leftText == rightText
//    case (.updateDescription(let leftText), .updateDescription(let rightText)):
//      return leftText == rightText
//    case (.removeRoutine, .removeRoutine):
//      return true
//    case (.fromActivityElements(id: let leftId, action: .removeActivity), .fromActivityElements(id: let rightId, action: .removeActivity)):
//      return leftId == rightId
//    default:
//      return true
//    }
//  }
//}
