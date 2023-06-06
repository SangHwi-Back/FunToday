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
      var container = RoutineInputFeature.State(routine: $0)
      container.routine.activities = $0.activities
      routineResult.append(container)
    }
    
    return GoalInputFeature.State(goal: self, routines: routineResult)
  }
}
