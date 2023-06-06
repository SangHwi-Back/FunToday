//
//  ActivityInputContainer.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/12.
//

import SwiftUI
import ComposableArchitecture

struct ActivityContainerView: View {
  let store: StoreOf<ActivityContainerFeature>
  @State private var showModal = false
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewstore in
      GeometryReader { proxy in
        VStack(spacing: 12) {
          ActivityButtonScrollView(store: store)
            .frame(height: 24)
            .padding(.vertical)
          ActivityInputScrollView(store: store, size: proxy.size)
        }
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            showModal.toggle()
          }, label: {
            Image(systemName: "list.bullet")
          })
          .sheet(isPresented: $showModal) {
            ActivityPresetListView(store: store.scope(
              state: \.presetActivity,
              action: ActivityContainerFeature.Action.presetElement(action:))
            )
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            viewstore.send(.addActivity)
          }, label: {
            Image(systemName: "plus")
          })
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("활동 추가")
      .padding()
    }
  }
}

struct ActivityButtonScrollView: View {
  let store: StoreOf<ActivityContainerFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewstore in
      ScrollView(.horizontal) {
        HStack(spacing: 18) {
          ForEachStore(
            store.scope(state: \.activities, action: ActivityContainerFeature.Action.activityElement(id:action:))
          ) {
            ActivityButton(store: $0)
          }
        }
      }
    }
  }
  
  struct ActivityButton: View {
    let store: StoreOf<ActivityInputFeature>
    
    var body: some View {
      WithViewStore(store, observe: { $0 }) { viewstore in
        Button {
          viewstore.send(.buttonTapped(id: viewstore.id, buttontype: .basic))
        } label: {
          ZStack {
            RoundedRectangle(cornerRadius: 8)
              .strokeBorder(Color.gray, lineWidth: 2)
            Text(viewstore.activity.name)
              .foregroundColor(Color.label)
              .padding()
          }
          .overlay({
            GeometryReader { proxy in
              FloatingMinusButton(width: 24) {
                viewstore.send(.buttonTapped(id: viewstore.id, buttontype: .minus))
              }
              .offset(x: -24, y: -24)
            }
          }())
        }
      }
    }
  }
}

struct ActivityInputScrollView: View {
  let store: StoreOf<ActivityContainerFeature>
  
  var size: CGSize
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewstore in
      ScrollView(.horizontal) {
        TabView {
          ForEachStore(
            store.scope(state: \.activities, action: ActivityContainerFeature.Action.activityElement(id:action:))
          ) {
            ActivityInputView(store: $0)
          }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: viewstore.activities.isEmpty ? .never : .always))
        .navigationBarTitleDisplayMode(.inline)
        .frame(width: size.width, height: size.height - 16)
      }
    }
  }
}

struct ActivityContainer_Previews: PreviewProvider {
  static var previews: some View {
    let initialStore = Store(
      initialState: ActivityContainerFeature.State(
        activities: .init(),
        presetActivity: .init(list: [])),
      reducer: { ActivityContainerFeature() })
    
    return ActivityContainerView(store: initialStore)
  }
}
