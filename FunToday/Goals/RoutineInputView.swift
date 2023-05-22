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
              ActivityInputContainer(
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

struct RoutineInputFeature: ReducerProtocol {
  struct State: Equatable, Identifiable {
    var id: UUID = .init()
    var routine: Routine
    var activities: IdentifiedArrayOf<ActivityContainerFeature.State>
  }
  
  enum Action {
    case updateName(String)
    case updateDescription(String)
    case removeRoutine
    case activityContainerElement(id:ActivityContainerFeature.State.ID, action: ActivityContainerFeature.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .updateName(let txt):
        state.routine.name = txt
        return .none
      case .updateDescription(let txt):
        state.routine.description = txt
        return .none
      case .removeRoutine:
        return .none
      case .activityContainerElement(id: let id, action: .removeActivity):
        state.activities.remove(id: id)
        return .none
      case .activityContainerElement:
        return .none
      }
    }.forEach(\.activities, action: /Action.activityContainerElement(id:action:)) {
      ActivityContainerFeature()
    }
  }
}
