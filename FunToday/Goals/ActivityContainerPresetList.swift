//
//  ActivityContainerPresetList.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/26.
//

import SwiftUI
import ComposableArchitecture

struct ActivityContainerPresetListView: View {
  let store: StoreOf<ActivityContainerPresetListFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewstore in
      List(viewstore.list) { activity in
        Button {
          viewstore.send(.rowSelected(activity))
        } label: {
          Text(activity.name)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
      }.onAppear {
        viewstore.send(.setList)
      }
    }
  }
}

struct ActivityContainerPresetListFeature: ReducerProtocol {
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
      state.list = MemoryStore.DP.loadAll()
        .compactMap({
          try? JSONDecoder().decode(Activity.self, from: $0)
        })
      return .none
    case .rowSelected(_):
      return .none
    }
  }
}
