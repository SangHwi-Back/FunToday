//
//  ActivityPresetListView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/26.
//

import SwiftUI
import ComposableArchitecture

struct ActivityPresetListView: View {
  let store: StoreOf<ActivityPresetListFeature>
  
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
