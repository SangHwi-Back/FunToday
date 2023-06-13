//
//  SettingActivityPresetView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/25.
//

import SwiftUI
import ComposableArchitecture

struct SettingActivityPresetView: View {
  let store: StoreOf<SettingActivityPresetFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewstore in
      ZStack(alignment: .bottomTrailing) {
        List {
          ForEachStore(
            store.scope(state: \.activities, action: SettingActivityPresetFeature.Action.fromActivityItems(id:action:))
          ) { detailStore in
            NavigationLink {
              SettingActivityPresetDetail(store: detailStore)
            } label: {
              WithViewStore(detailStore) { viewstore in
                Text(viewstore.activity.name)
              }
            }
          }
        }
        
        NavigationLink {
          SettingActivityPresetInsert(store: store.scope(
            state: \.newActivity,
            action: SettingActivityPresetFeature.Action.fromActivityNewItem(action:)))
        } label: {
          FloatingPlusButton(width: 54)
        }
      }
      .onAppear {
        viewstore.send(.setList)
      }
    }
  }
}

struct SettingActivityPresetInsert: View {
  @Environment(\.presentationMode) var presentationMode
  let store: StoreOf<ActivityInputFeature>
  
  var body: some View {
    WithViewStore(store) { viewstore in
      VStack(spacing: 8) {
        ActivityInputView(store: store)
        
        HStack {
          Button("취소") {
            presentationMode.wrappedValue.dismiss()
          }
          .buttonStyle(CommonPushButtonStyle())
          Spacer()
          Button("등록하기") {
            viewstore.send(.addActivity)
            presentationMode.wrappedValue.dismiss()
          }
          .buttonStyle(CommonPushButtonStyle())
        }
        
        Spacer()
      }
      .padding()
    }
  }
}

struct SettingActivityPresetDetail: View {
  @State var showAlert = false
  let store: StoreOf<ActivityInputFeature>
  
  var body: some View {
    WithViewStore(store) { viewstore in
      ActivityInputView(store: store)
        .padding()
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button { showAlert.toggle() } label: {
              Image(systemName: "xmark")
                .resizable()
                .accentColor(.red)
            }
          }
        }
        .alert(isPresented: $showAlert) {
          Alert(
            title: Text("활동 삭제"),
            message: Text("활동이 삭제됩니다. 진행하시겠습니까?"),
            primaryButton: .default(Text("예")) {
              viewstore.send(.removeActivity)
              showAlert.toggle()
            },
            secondaryButton: .cancel(Text("아니오")) {
              showAlert.toggle()
            }
          )
        }
    }
  }
}

struct SettingActivityPresetView_Preview: PreviewProvider {
  static var previews: some View {
    SettingActivityPresetView(
      store: Store(
        initialState: SettingActivityPresetFeature.State(
          activities: .init(),
          newActivity: .init(activity: Activity.getDouble())),
        reducer: {
          SettingActivityPresetFeature()
        }
      )
    )
  }
}
