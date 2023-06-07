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
    
    let dateFormatter: DateFormatter = {
      let format = DateFormatter()
      format.dateFormat = "yyyy-MM-dd"
      return format
    }()
    
    var startDate: Date = Date()
    var endDate: Date = Date()
    var category = ActivityCategory.health
    var countAlertPresented = false
  }
  
  enum Action {
    case updateName(String)
    case updateDescription(String)
    case updateCategory(ActivityCategory)
    case updateStartDate(Date)
    case updateEndDate(Date)
    case updateDailyActive
    case updateWeekendActive
    case updateActive
    case updateUseSwitch
    case updateSlider(Float)
    /// true : +, false : -
    case updateCount(Bool)
    case showCountAlert
    case removeActivity
    case addActivity
    case buttonTapped(id: State.ID, buttontype: ActivityHeaderButtonType)
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
    case .updateStartDate(let date):
      state.activity.time_s = state.dateFormatter.string(from: date)
      state.startDate = date
      return .none
    case .updateEndDate(let date):
      state.activity.time_e = state.dateFormatter.string(from: date)
      state.endDate = date
      return .none
    case .updateDailyActive:
      state.activity.isDailyActive.toggle()
      return .none
    case .updateWeekendActive:
      state.activity.isWeekendActive.toggle()
      return .none
    case .updateActive:
      state.activity.isActive.toggle()
      return .none
    case .updateUseSwitch:
      state.activity.completionUseSwitch.toggle()
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
    case .removeActivity:
      return .none
    case .addActivity:
      return .none
    case .buttonTapped:
      return .none
    }
  }
  
  enum ActivityHeaderButtonType {
    case basic, minus
  }
}
