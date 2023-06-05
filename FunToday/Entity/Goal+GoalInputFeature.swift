//
//  Goal+GoalInputFeature.swift
//  FunToday
//
//  Created by 백상휘 on 2023/06/05.
//

import Foundation
import IdentifiedCollections

extension Goal {
  func toState() -> GoalInputFeature.State {
    var routineResult = IdentifiedArrayOf<RoutineInputFeature.State>()
    routines.forEach {
      routineResult.append(RoutineInputFeature.State(routine: $0))
    }
    
    return GoalInputFeature.State(goal: self, routines: routineResult)
  }
}
