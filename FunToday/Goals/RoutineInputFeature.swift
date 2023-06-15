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
      case .fromActivityElements(id: let id, action: let action):
        guard let inx = state.containerState.activities.firstIndex(where: { $0.id == id }) else {
          return .none
        }
        
        switch action {
        case .removeActivity:
          state.routine.activities.remove(at: inx)
          
        default:
          state.routine.activities[inx] = state.containerState.activities[inx].activity
        }
        
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
