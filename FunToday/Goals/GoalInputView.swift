//
//  GoalInputView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/11.
//

import SwiftUI
import ComposableArchitecture

struct GoalInputView: View {
  @Environment(\.presentationMode) var presentationMode
  
  let store: StoreOf<GoalInputFeature>
  
  @State var showAlert = false
  
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
          
          ZStack {
            RoundedRectangle(cornerRadius: 8)
              .strokeBorder(Color.gray)
              .background(Color.labelReversed)
              .onTapGesture { showAlert.toggle() }
              .alert(isPresented: $showAlert) {
                Alert(
                  title: Text("목표 추가"),
                  message: Text("정말로 목표를 추가하시겠습니까?"),
                  primaryButton: .default(Text("예")) {
                    viewstore.send(.addGoal)
                    presentationMode.wrappedValue.dismiss()
                  },
                  secondaryButton: .cancel(Text("아니오")) { showAlert.toggle() }
                )
              }
            Text("목표 등록")
              .foregroundColor(Color.label)
              .fontWeight(.heavy)
              .padding()
              .allowsHitTesting(false)
          }
        }.padding()
      }
      .navigationBarTitleDisplayMode(.large)
      .navigationTitle("목표 추가")
      .onDisappear {
        viewstore.send(.resetGoal)
      }
    }
  }
}

struct GoalInputView_Previews: PreviewProvider {
  static var previews: some View {
    let initialStore = Store(
      initialState: GoalInputFeature.State(goal: Goal.getDouble(), routines: .init()),
      reducer: { GoalInputFeature() })
    
    return GoalInputView(store: initialStore)
  }
}
