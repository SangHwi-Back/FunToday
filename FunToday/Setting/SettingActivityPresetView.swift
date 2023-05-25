//
//  SettingActivityPresetView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/25.
//

import SwiftUI
import ComposableArchitecture

struct SettingActivityPresetView: View {
  @Environment(\.presentationMode) var presentationMode
  let store: StoreOf<SettingActivityPresetFeature>
  @State var showModal = false
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewstore in
      ScrollView {
        VStack(spacing: 4) {
          ForEachStore(
            store.scope(state: \.activities, action: SettingActivityPresetFeature.Action.activityItems(id:action:))
          ) {
            let store = $0
            NavigationLink {
              ActivityInputView(store: store)
            } label: {
              SettingActivityPresetRowContent(store: store)
            }
          }
        }
        .navigationBarItems(trailing: Button("+") {
          showModal.toggle()
        })
        .fullScreenCover(isPresented: $showModal) {
          VStack {
            ActivityInputView(
              store: store.scope(
                state: \.newActivity,
                action: SettingActivityPresetFeature.Action.newItem(action:)))
            .padding()
            
            HStack {
              Button { showModal.toggle() } label: {
                Text("취소")
              }
              .buttonStyle(CommonPushButtonStyle())
              Spacer()
              Button { viewstore.send(.itemAdd); showModal.toggle() } label: {
                Text("등록하기")
              }
              .buttonStyle(CommonPushButtonStyle())
            }
            .padding()
            .padding(.bottom, 50)
          }
      }
      }
    }
  }
}

private struct SettingActivityPresetRowContent: View {
  let store: StoreOf<ActivityInputFeature>
  
  var body: some View {
    WithViewStore(store) { viewstore in
      Text(viewstore.activity.name)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
  }
}

struct SettingActivityPresetFeature: ReducerProtocol {
  struct State: Equatable {
    var activities: IdentifiedArrayOf<ActivityInputFeature.State>
    var newActivity: ActivityInputFeature.State = .init(activity: Activity.getDouble())
    
    var showModal: Bool = false
  }
  enum Action {
    case newItem(action:ActivityInputFeature.Action)
    case activityItems(id:ActivityInputFeature.State.ID,action:ActivityInputFeature.Action)
    case modalToggle
    case itemAdd
  }
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .newItem(action: .buttonTapped):
        state.activities.append(state.newActivity)
        state.newActivity = .init(activity: Activity.getDouble())
        return .none
      case .activityItems(id: _, action: .buttonTapped):
        return .none
      case .modalToggle:
        state.showModal.toggle()
        return .none
      case .itemAdd:
        return .send(.newItem(action: .buttonTapped(id: state.newActivity.id, buttontype: .basic)))
      case .newItem, .activityItems:
        return .none
      }
    }
    .forEach(\.activities, action: /Action.activityItems(id:action:)) {
      ActivityInputFeature()
    }
  }
}
