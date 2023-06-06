//
//  ActivityPresetListFeature.swift
//  FunToday
//
//  Created by 백상휘 on 2023/06/01.
//

import Foundation
import ComposableArchitecture

struct ActivityPresetListFeature: ReducerProtocol {
  struct State: Equatable {
    // MARK: Temporary code
    var list: [Activity]
    var selectedActivity: Activity?
  }
  
  enum Action {
    case setList
    case rowSelected(Activity)
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .setList:
      state.list = ActivityStore.DP.loadAll()
        .compactMap({
          try? JSONDecoder().decode(Activity.self, from: $0)
        })
      return .none
    case .rowSelected(_):
      return .none
    }
  }
}
