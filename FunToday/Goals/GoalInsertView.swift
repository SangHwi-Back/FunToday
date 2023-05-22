//
//  GoalInsertView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/11.
//

import SwiftUI
import ComposableArchitecture

struct GoalInsertView: View {
  let store: StoreOf<GoalInputFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewstore in
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 8) {
          
          // MARK: - Goal Section
          InputField(
            title: "이름 :",
            isEssential: true,
            text: viewstore.binding(get: \.goal.name, send: GoalInputFeature.Action.updateName))
          InputField(
            title: "설명 :",
            isEssential: false,
            text: viewstore.binding(get: \.goal.description, send: GoalInputFeature.Action.updateDescription))
          
          // MARK: - Routines Section
          Text("루틴 \(viewstore.routines.count)")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical)
          
          VStack(spacing: 8) {
            ForEachStore(
              store.scope(state: \.routines, action: GoalInputFeature.Action.routineElement(id:action:))
            ) { storescoped in
              RoutineInputView(store: storescoped)
            }
            
            ZStack {
              RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.gray)

              FloatingPlusButton(width: 24, bgColor: .gray) {
                viewstore.send(.addRoutine)
              }
            }
          }
        }.padding()
      }
      .navigationBarTitleDisplayMode(.large)
    .navigationTitle("목표 추가")
    }
  }
}

struct GoalInsertView_Previews: PreviewProvider {
  static var previews: some View {
    let initialStore = Store.init(initialState: GoalInputFeature.State(
      goal: Goal.getDouble(),
      routines: .init()),
      reducer: {
        GoalInputFeature()
      }
    )
    
    return GoalInsertView(store: initialStore)
  }
}

struct GoalInputFeature: ReducerProtocol {
  struct State: Equatable, Identifiable {
    var goal: Goal
    var id: String {
      goal.uniqueID
    }
    
    var routines: IdentifiedArrayOf<RoutineInputFeature.State>
    var activeRoutine: Routine?
  }
  
  enum Action {
    case addRoutine
    case updateName(String)
    case updateDescription(String)
    case routineElement(id: RoutineInputFeature.State.ID, action: RoutineInputFeature.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .addRoutine:
        state.routines.append(
          RoutineInputFeature.State(routine: Routine.getDouble(), activities: .init())
        )
        return .none
      case .updateName(let txt):
        state.goal.name = txt
        return .none
      case .updateDescription(let txt):
        state.goal.description = txt
        return .none
      case .routineElement(id: let id, action: .removeRoutine):
        state.routines.remove(id: id)
        return .none
      case .routineElement:
        return .none
      }
    }.forEach(\State.routines, action: /Action.routineElement(id:action:)) {
      RoutineInputFeature()
    }
  }
}
