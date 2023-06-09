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
  
  @State var showRemoveAlert = false
  @State var showAddAlert = false
  @GestureState var dragstate: CGFloat = 0
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewstore in
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 8) {
          HStack {
            DatePicker("",
                       selection: Binding(
                        get: { viewstore.goal.startDate },
                        set: { viewstore.send(.updateDate(.start, $0)) }),
                       displayedComponents: [.date])
            DatePicker("",
                       selection: Binding(
                        get: { viewstore.goal.endDate },
                        set: { viewstore.send(.updateDate(.end, $0)) }),
                       displayedComponents: [.date])
            Spacer()
            
            HStack(spacing: 2) {
              Text(viewstore.dateDuration?.rawValue ?? "기간")
              Image.init(systemName: "chevron.down")
            }
            .padding(8)
            .background(Color.element.cornerRadius(8))
            .scaledToFit()
            .contextMenu {
              ForEach(GoalInputFeature.DateDuration.allCases, id: \.self) { duration in
                Button {
                  viewstore.send(.updateDateAsDuration(duration))
                } label: {
                  Text(duration.rawValue)
                }
              }
            }
          }
          .padding(.bottom, 6)
          
          // MARK: - Goal Section
          CustomSectionView {
            VStack(spacing: 8) {
              InputField(
                title: "이름 :",
                isEssential: true,
                text: viewstore.binding(
                  get: \.goal.name,
                  send: GoalInputFeature.Action.updateName))
              InputField(
                title: "설명 :",
                isEssential: false,
                text: viewstore.binding(
                  get: \.goal.description,
                  send: GoalInputFeature.Action.updateDescription))
            }
          }
          
          // MARK: - Routines Section
          Text("루틴")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top)
          
          ForEachStore(
            store.scope(state: \.routines, action: GoalInputFeature.Action.fromRoutineElement(id:action:))
          ) {
            RoutineInputView(store: $0)
          }
          
          ZStack {
            RoundedRectangle(cornerRadius: 8)
              .strokeBorder(Color.gray)
            FloatingPlusButton(width: 24, bgColor: .gray)
          }.onTapGesture {
            viewstore.send(.addRoutine)
          }
          
          if viewstore.isNew {
            Divider().padding(.vertical)
            
            ZStack {
              RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.gray)
                .background(Color.labelReversed)
                .alert(isPresented: $showAddAlert) {
                  Alert(
                    title: Text("목표 추가"),
                    message: Text("정말로 목표를 추가하시겠습니까?"),
                    primaryButton: .default(Text("예")) {
                      viewstore.send(.addGoal)
                      presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel(Text("아니오")) {
                      showAddAlert.toggle()
                    }
                  )
                }
              Text("목표 등록")
                .foregroundColor(Color.label)
                .fontWeight(.heavy)
                .padding()
                .allowsHitTesting(false)
            }
            .onTapGesture {
              showAddAlert.toggle()
            }
          }
        }.padding()
      }
      .navigationBarBackButtonHidden(true)
      .navigationBarTitleDisplayMode(.large)
      .navigationTitle("목표\(viewstore.isNew ? " 추가" : "")")
      .navigationBarItems(leading: Button(viewstore.isNew ? "취소" : "뒤로가기") {
        if viewstore.isNew {
          viewstore.send(.resetGoal)
        } else {
          viewstore.send(.saveGoal)
        }
        
        presentationMode.wrappedValue.dismiss()
      }.buttonStyle(CommonPushButtonStyle()))
      .if(viewstore.isNew == false) {
        $0.navigationBarItems(trailing: Button("삭제하기") {
          showRemoveAlert.toggle()
        }.buttonStyle(CommonPushButtonStyle()))
        .alert(isPresented: $showRemoveAlert, content: {
          Alert(
            title: Text("목표 삭제"),
            message: Text("정말로 목표를 삭제하시겠습니까?"),
            primaryButton: .default(Text("예")) {
              viewstore.send(.removeGoal)
              presentationMode.wrappedValue.dismiss()
            },
            secondaryButton: .cancel(Text("아니오")) {
              showRemoveAlert.toggle()
            }
          )
        })
      }
      .gesture(DragGesture().updating($dragstate, body: { value, state, transaction in
        if (value.startLocation.x < 15 && value.translation.width > 70) {
          viewstore.send(.resetGoal)
          presentationMode.wrappedValue.dismiss()
        }
      }))
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
