//
//  GoalInputFeature.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/22.
//

import Foundation
import ComposableArchitecture

struct GoalInputFeature: ReducerProtocol {
  struct State: Equatable, Identifiable {
    var goal: Goal
    var id: String {
      goal.id
    }
    var routines: IdentifiedArrayOf<RoutineInputFeature.State>
    var dateDuration: DateDuration?
    var isNew: Bool = false
  }
  
  enum Action {
    case addGoal
    case removeGoal
    case saveGoal
    case addRoutine
    case resetGoal
    case setFold
    case updateDate(DateType, Date)
    case updateDateAsDuration(DateDuration)
    case updateName(String)
    case updateDescription(String)
    
    case fromRoutineElement(id: RoutineInputFeature.State.ID, action: RoutineInputFeature.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .removeGoal:
        return .none
      case .saveGoal:
        state.goal.routines = state.routines.elements.map({$0.routine})
        return .none
      case .addRoutine:
        let routine = Routine.getDouble()
        state.routines.append(.init(routine: routine, isNew: state.isNew))
        state.goal.routines.append(routine)
        return .none
      case .resetGoal:
        state.goal = Goal.getDouble()
        state.routines = []
        return .none
      case .setFold:
        state.goal.isFold.toggle()
        return .none
      case .updateDate(let type, let date):
        let keyPath = type == .start ? \Goal.startDate : \Goal.endDate
        state.goal[keyPath: keyPath] = date
        return .none
      case .updateDateAsDuration(let duration):
        let dates = state.goal.time_s.split(separator: "-")
        guard dates.count >= 3, let year = Int(dates[0]), let month = Int(dates[1]), let day = Int(dates[2]) else {
          return .none
        }
        
        var components = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: year, month: month, day: day)
        
        switch duration {
        case .five: if let value = components.day {
          components.day = value + 5
        }
        case .seven: if let value = components.day {
          components.day = value + 7
        }
        case .month: if let value = components.month {
          components.month = value + 1
        }
        case .halfOfYear: if let value = components.month {
          components.month = value + 6
        }
        case .year: if let value = components.year {
          components.year = value + 1
        }
        }
        
        if let date = components.date {
          state.dateDuration = duration
          state.goal.startDate = Date()
          state.goal.endDate = date
        }
        
        return .none
      case .updateName(let txt):
        state.goal.name = txt
        return .none
      case .updateDescription(let txt):
        state.goal.description = txt
        return .none
      case .fromRoutineElement(id: let id, action: .removeRoutine):
        state.routines.remove(id: id)
        return .run { await $0(.saveGoal) }
      case .addGoal, .fromRoutineElement:
        return .run { await $0(.saveGoal) }
      }
    }
    .forEach(\.routines, action: /Action.fromRoutineElement(id:action:)) {
      RoutineInputFeature()
    }
  }
  
  enum DateType {
    case start, end
  }
  
  enum DateDuration: String, CaseIterable {
    case five, seven, month, halfOfYear, year
  }
  
  struct Alert: Equatable {
    var lessThanZeroCount = false
    var exeededCount = false
    var lessThanEndDate = false
    var greaterThanStartDate = false
  }
}
