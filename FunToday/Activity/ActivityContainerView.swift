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
          ActivityButtonScrollView(store: store, size: proxy.size)
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
      .navigationTitle("활동 추가 "+viewstore.routineDateTitle)
      .padding(.horizontal)
    }
  }
}

struct ActivityButtonScrollView: View {
  let store: StoreOf<ActivityContainerFeature>
  let size: CGSize
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewstore in
      ScrollView(.horizontal) {
        if viewstore.activities.isEmpty == false {
          TabView(selection: viewstore.binding(
            get: \.currentIndex,
            send: ActivityContainerFeature.Action.setIndex)
          ) {
            ForEach(viewstore.activities, id: \.id) { inputState in
              Button {
                viewstore.send(.buttonTapped(inputState.id))
              } label: {
                ZStack(alignment: .topLeading) {
                  CustomSectionView {
                    Text(inputState.activity.name)
                      .foregroundColor(Color.label)
                      .padding(.horizontal, 48)
                      .truncationMode(.tail)
                  }
                  .padding(12)
                }
                .frame(height: 48)
                .overlay(
                  FloatingMinusButton(width: 24) {
                    viewstore.send(.fromActivityElements(id: inputState.activity.id, action: .removeActivity))
                  }.offset(x: -12, y: -12),
                  alignment: .topLeading
                )
              }
              .tag(inputState.id)
            }
          }
          .animation(.easeIn)
          .transition(.slide)
          .frame(width: size.width, height: 60)
          .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
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
        if viewstore.activities.isEmpty == false {
          TabView(selection: viewstore.binding(
            get: \.currentIndex,
            send: ActivityContainerFeature.Action.setIndex)
          ) {
            ForEachStore(
              store.scope(state: \.activities, action: ActivityContainerFeature.Action.fromActivityElements(id:action:))
            ) {
              ActivityInputView(store: $0)
                .tag(ViewStoreOf<ActivityInputFeature>($0).id)
            }
          }
          .animation(.easeIn)
          .transition(.slide)
          .frame(width: size.width)
          .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
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
