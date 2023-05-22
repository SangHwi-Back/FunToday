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

            Text("활동")
              .frame(maxWidth: .infinity, alignment: .leading)
            
            NavigationLink {
              ActivityContainer(
                store: Store(
                  initialState: ActivityContainerFeature.State(
                    activities: .init()
                  ),
                  reducer: {
                    ActivityContainerFeature()
                  }
                )
              )
            } label: {
              Text("Put some Input activities")
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

struct RoutineInputView_Preview: PreviewProvider {
  static var previews: some View {
    let initialStore = Store(
      initialState: RoutineInputFeature.State(routine: Routine.getDouble(), activities: .init()),
      reducer: { RoutineInputFeature() })
    
    return RoutineInputView(store: initialStore)
  }
}
