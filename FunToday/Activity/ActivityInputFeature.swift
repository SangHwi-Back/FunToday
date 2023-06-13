//
//  ActivityInputFeature.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/22.
//

import Foundation
import ComposableArchitecture

struct ActivityInputFeature: ReducerProtocol {
  
  let dateFormatter: DateFormatter = {
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd"
    return format
  }()
  
  struct State: Equatable, Identifiable {
    var id: String {
      activity.id
    }
    var activity: Activity
    
    var startDate: Date = Date()
    var endDate: Date = Date()
    var category = Activity.Category.health
    var countAlertPresented = false
    var activeToday = true
    var completionAs: CompletionAs? {
      activity.completionAs.toCompletionType()
    }
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
    case showCountAlert
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
      state.category = category
      return .none
    case .updateDate(let dateType, let date):
      switch dateType {
      case .start:
        state.activity.time_s = dateFormatter.string(from: date)
        state.startDate = date
      case .end:
        state.activity.time_e = dateFormatter.string(from: date)
        state.endDate = date
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
    case .updateSlider(let ratio):
      state.activity.ratio = ratio
      return .none
    case .updateCount(let willPlus):
      if willPlus == false, state.activity.completionCount == 0 {
        return .run { send in await send(.showCountAlert) }
      }
      
      state.activity.completionCount += (willPlus ? 1 : -1)
      return .none
    case .showCountAlert:
      state.countAlertPresented.toggle()
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
