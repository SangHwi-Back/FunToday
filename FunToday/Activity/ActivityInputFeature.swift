//
//  ActivityInputFeature.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/22.
//

import Foundation
import ComposableArchitecture

struct ActivityInputFeature: ReducerProtocol {
  struct State: Equatable, Identifiable {
    var id: String {
      activity.id
    }
    var activity: Activity
    
    var isNew = false
    var alertState = Alert()
    var activeToday = true
    
    var completionAs: CompletionAs? {
      activity.completionAs.toCompletionType()
    }
    var currentRatio: Float {
      get {
        Float(isNew ? activity.completionRatio : activity.ratioCompletion) / 100
      }
    }
    var currentCount: Int {
      get {
        isNew ? activity.completionCount : activity.countCompletion
      }
    }
    var routineDateTitle: String = ""
  }
  
  enum Action {
    case updateName(String)
    case updateDescription(String)
    case updateCategory(Activity.Category)
    case updateDate(ActivityDate, Date)
    case updateActiveStart(Bool)
    case updateViewActive(ActivityInstants)
    case updateWeekDay(Activity.Weekday)
    case updateWeekend(Activity.Weekend)
    case updateSlider(Float)
    /// true : +, false : -
    case updateCount(Bool)
    case showAlert(WritableKeyPath<Alert, Bool>)
    
    case removeActivity
    case addActivity
    case completionSwitchTapped(CompletionAs?)
    
    case fromContainerHeaderButtonTapped(id: State.ID, buttontype: ActivityHeaderButtonType)
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .updateName(let txt):
      state.activity.name = txt
      return .none
    case .updateDescription(let txt):
      state.activity.description = txt
      return .none
    case .updateCategory(let category):
      state.activity.categoryValue = category.rawValue
      return .none
    case .updateDate(let dateType, let newDate):
      switch dateType {
      case .start:
        guard newDate < state.activity.endDate else {
          return .run { await $0(.showAlert(\.lessThanEndDate)) }
        }
        
        state.activity.startDate = newDate
      case .end:
        guard newDate > state.activity.startDate else {
          return .run { await $0(.showAlert(\.greaterThanStartDate)) }
        }
        
        state.activity.endDate = newDate
      }
      return .none
    case .updateWeekDay(let val):
      if state.activity.activeWeekDays.contains(val) {
        state.activity.activeWeekDays.remove(val)
      }
      else {
        state.activity.activeWeekDays.insert(val)
      }
      return .none
    case .updateWeekend(let val):
      if state.activity.activeWeekends.contains(val) {
        state.activity.activeWeekends.remove(val)
      }
      else {
        state.activity.activeWeekends.insert(val)
      }
      return .none
    case .updateActiveStart:
      state.activeToday.toggle()
      return .none
    case .updateViewActive(let val):
      switch val {
      case .dailySchedule:
        state.activity.isDailyActive.toggle()
      case .weekendSchedule:
        state.activity.isWeekendActive.toggle()
      case .startNowOrTomorrow:
        state.activity.isActive.toggle()
      }
      return .none
    case .updateSlider(let value):
      let ratio = Int(floor(value * 100))
      let keyPath: WritableKeyPath<Activity, Int> = state.isNew ? \.completionRatio : \.ratioCompletion
      state.activity[keyPath: keyPath] = ratio
      return .none
    case .updateCount(let willPlus):
      let value = state.currentCount + (willPlus ? 1 : -1)
      
      if value < 0 {
        return .run { send in
          await send(.showAlert(\.lessThanZeroCount))
        }
      }
      else if state.isNew == false, state.activity.completionCount < value {
        return .run { send in
          await send(.showAlert(\.exeededCount))
        }
      }
      
      let keyPath: WritableKeyPath<Activity, Int> = state.isNew ? \.completionCount : \.countCompletion
      state.activity[keyPath: keyPath] = value
      return .none
    case .showAlert(let keyPath):
      state.alertState[keyPath: keyPath].toggle()
      return .none
    case .completionSwitchTapped(let completionAs):
      state.activity.completionAs = completionAs?.rawValue ?? 0
      return .none
    case .removeActivity, .addActivity, .fromContainerHeaderButtonTapped:
      return .none
    }
  }
  
  enum ActivityHeaderButtonType {
    case basic, minus
  }
  
  enum ActivityDate {
    case start, end
  }
  
  enum ActivityInstants {
    case dailySchedule, weekendSchedule, startNowOrTomorrow
  }
  
  struct Alert: Equatable {
    var lessThanZeroCount = false
    var exeededCount = false
    var lessThanEndDate = false
    var greaterThanStartDate = false
  }
}

enum CompletionAs: Int {
  case count = 1, slider = 2
}

extension Int {
  func toCompletionType() -> CompletionAs? {
    switch self {
    case 1: return .count
    case 2: return .slider
    default: return nil
    }
  }
}
