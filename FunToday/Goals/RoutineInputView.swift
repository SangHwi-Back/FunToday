//
//  RoutineInputView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/11.
//

import SwiftUI
import ComposableArchitecture

struct RoutineInputView: View {
  let store: StoreOf<RoutineInputFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewstore in
      ZStack(alignment: .topLeading) {
        CustomSectionView {
          VStack(spacing: 4) {
            
            InputField(title: "이름 :",
                       isEssential: true,
                       text: viewstore.binding(get: \.routine.name, send: RoutineInputFeature.Action.updateName))
            InputField(title: "설명 :",
                       isEssential: false,
                       text: viewstore.binding(get: \.routine.description, send: RoutineInputFeature.Action.updateDescription))
            
            Divider().padding(.vertical)
            
            Text("활동")
              .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 8) {
              ForEachStore(
                store.scope(state: \.containerState.activities, action: RoutineInputFeature.Action.activityElements(id:action:))
              ) { store in
                NavigationLink {
                  ActivityInputView(store: store).padding()
                } label: {
                  ActivityElementInRoutine(store: store)
                }
              }
            }
            .padding(.vertical)
            
            NavigationLink {
              ActivityContainer(
                store: store.scope(
                  state: \.containerState,
                  action: RoutineInputFeature.Action.activityContainerElement(action:))
              )
            } label: {
              Text("활동 추가하기")
            }
          }
        }
        
        FloatingMinusButton(width: 24) {
          viewstore.send(.removeRoutine)
        }
        .offset(x: -24, y: -24)
      }
    }
  }
}

struct ActivityElementInRoutine: View {
  let store: StoreOf<ActivityInputFeature>
  
  var body: some View {
    WithViewStore(store) { viewstore in
      ZStack {
        CommonRectangle(color: Binding.constant(Color.cell))
          .overlay(FloatingMinusButton(width: 24) {
            viewstore.send(.removeActivity)
          }.offset(x: -24, y: -24),
          alignment: .topLeading)
        Text(viewstore.activity.name)
          .frame(maxWidth: .infinity, alignment: .leading)
          .foregroundColor(Color.label)
          .padding()
      }
    }
  }
}

struct RoutineInputView_Preview: PreviewProvider {
  static var previews: some View {
    let initialStore = Store(
      initialState: RoutineInputFeature.State(routine: Routine.getDouble()),
      reducer: { RoutineInputFeature() })
    
    return RoutineInputView(store: initialStore)
  }
}
