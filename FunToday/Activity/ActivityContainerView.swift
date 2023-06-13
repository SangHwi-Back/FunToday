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
            let childStore = store.scope(state: \.presetActivity, action: ActivityContainerFeature.Action.fromPresetElements(action:))
            ActivityPresetListView(store: childStore)
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
        HStack(spacing: 6) {
          ForEach(viewstore.activities, id: \.id) { inpuState in
            Button {
              viewstore.send(.buttonTapped(inpuState.id))
            } label: {
              CustomSectionView {
                Text(inpuState.activity.name)
                  .foregroundColor(Color.label)
              }
              .overlay({
                GeometryReader { proxy in
                  FloatingMinusButton(width: 24) {
                    viewstore.send(.fromActivityElements(id: inpuState.activity.id, action: .removeActivity))
                  }
                  .offset(x: -24, y: -24)
                }
              }())
            }
            .padding([.top, .leading], 12)
          }
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
        TabView(selection: viewstore.binding(
          get: \.currentIndex,
          send: { ActivityContainerFeature.Action.setIndex($0) })
        ) {
          ForEachStore(
            store.scope(state: \.activities, action: ActivityContainerFeature.Action.fromActivityElements(id:action:))
          ) {
            ActivityInputView(store: $0)
              .tag(ViewStoreOf<ActivityInputFeature>($0).id)
          }
        }
        .tabViewStyle(PageTabViewStyle())
        .navigationBarTitleDisplayMode(.inline)
        .frame(width: size.width)
      }
    }
  }
}

struct ActivityContainer_Previews: PreviewProvider {
  static var previews: some View {
    let routineFeature = Store(initialState: RoutineInputFeature.State(routine: Routine.getDouble()), reducer: RoutineInputFeature())
    
    return NavigationView {
      ActivityContainerView(store: routineFeature.scope(state: \.containerState, action: RoutineInputFeature.Action.fromActivityContainerElements(action:)))
    }
  }
}
