//
//  ActivityContainerFeature.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/22.
//

import Foundation
import ComposableArchitecture

struct ActivityContainerFeature: ReducerProtocol {
  struct State: Equatable, Identifiable {
    static func == (lhs: ActivityContainerFeature.State, rhs: ActivityContainerFeature.State) -> Bool {
      lhs.id == rhs.id
    }
    var id: UUID = .init()
    var activities: IdentifiedArrayOf<ActivityInputFeature.State>
  }
  
  enum Action {
    case addActivity
    case removeActivity
    case activityElement(id: ActivityInputFeature.State.ID, action: ActivityInputFeature.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .addActivity:
        state.activities.append(.init(activity: Activity.getDouble()))
        return .none
      case .removeActivity:
        return .none
      case .activityElement(id: let id, action: .removeActivity):
        state.activities.remove(id: id)
        return .none
      case .activityElement:
        return .none
      }
    }.forEach(\.activities, action: /Action.activityElement(id:action:)) {
      ActivityInputFeature()
    }
  }
  
  // MARK: - Inner State
  enum ActivityHeaderButtonType {
    case basic, minus
  }
}
