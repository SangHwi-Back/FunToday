//
//  ActivityInputView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/11.
//

import SwiftUI
import ComposableArchitecture

struct ActivityInputView: View {
  let store: StoreOf<ActivityInputFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewstore in
      CustomSectionView {
        ScrollView {
          InputField(title: "이름 :", isEssential: true,
                     text: viewstore.binding(get: \.activity.name, send: ActivityInputFeature.Action.updateName))
          InputField(title: "설명 :", isEssential: false,
                     text: viewstore.binding(get: \.activity.description, send: ActivityInputFeature.Action.updateDescription))
          
          HStack(spacing: 12) {
            Text("카테고리")
            Picker("종류", selection: viewstore.binding(get: \.category, send: ActivityInputFeature.Action.updateCategory)) {
              ForEach(Activity.Category.allCases, id: \.rawValue) { category in
                Text(String(describing: category))
                  .tag(category)
              }
            }
            .frame(maxWidth: .infinity)
            .background(Color.element)
            .clipShape(RoundedRectangle(cornerRadius: 8))
          }
          .padding(.vertical, 4)
          
          HStack {
            Text("기간")
            Spacer()
            DatePicker("", selection: viewstore.binding(get: \.startDate, send: ActivityInputFeature.Action.updateStartDate), displayedComponents: [.hourAndMinute])
            Text("~")
            DatePicker("", selection: viewstore.binding(get: \.endDate, send: ActivityInputFeature.Action.updateEndDate), displayedComponents: [.hourAndMinute])
          }
          .padding(.vertical, 4)
          
          ActivityInputViewDailyHandler(viewstore: viewstore)
          
          ActivityInputViewWeekendHandler(viewstore: viewstore)
          
          ActivityInputViewIsActiveHandler(viewstore: viewstore)
          
          ActivityInputViewCompletionValueHandler(viewstore: viewstore)
        }
      }
      .animation(.default, value: viewstore.activity)
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

private struct ActivityInputViewDailyHandler: View {
  let viewstore: ViewStore<ActivityInputFeature.State, ActivityInputFeature.Action>
  
  var body: some View {
    VStack {
      Toggle("매일 진행하나요?", isOn: viewstore.binding(get: \.activity.isDailyActive, send: ActivityInputFeature.Action.updateDailyActive))
      
      if viewstore.activity.isDailyActive == false {
          Divider()
          HStack(spacing: 0) {
            getText("월요일", isActive: viewstore.activity.activeWeekDays.contains(.mon))
              .onTapGesture { viewstore.send(.updateWeekDay(.mon)) }
            Divider()
            getText("화요일", isActive: viewstore.activity.activeWeekDays.contains(.tue))
              .onTapGesture { viewstore.send(.updateWeekDay(.tue)) }
            Divider()
            getText("수요일", isActive: viewstore.activity.activeWeekDays.contains(.wed))
              .onTapGesture { viewstore.send(.updateWeekDay(.wed)) }
            Divider()
            getText("목요일", isActive: viewstore.activity.activeWeekDays.contains(.thu))
              .onTapGesture { viewstore.send(.updateWeekDay(.thu)) }
            Divider()
            getText("금요일", isActive: viewstore.activity.activeWeekDays.contains(.fri))
              .onTapGesture { viewstore.send(.updateWeekDay(.fri)) }
          }
          .clipShape(RoundedRectangle(cornerRadius: 8))
          Divider()
      }
    }
  }
  
  private func getText(_ txt: String, isActive: Bool) -> some View {
    Text(txt)
      .minimumScaleFactor(0.2)
      .padding(.horizontal).padding(.vertical, 12)
      .scaledToFill()
      .foregroundColor(isActive ? .white : .label)
      .background(isActive ? Color.green : Color.element)
  }
}

private struct ActivityInputViewWeekendHandler: View {
  let viewstore: ViewStore<ActivityInputFeature.State, ActivityInputFeature.Action>
  
  var body: some View {
    VStack {
      Toggle("주말에도 진행하나요?", isOn: viewstore.binding(get: \.activity.isWeekendActive, send: ActivityInputFeature.Action.updateWeekendActive))
      
      if viewstore.activity.isWeekendActive {
        VStack {
          Divider()
          HStack {
            Spacer()
            HStack(spacing: 0) {
              Button(action: { viewstore.send(.updateWeekend(.sat)) }) {
                Text("토요일")
                  .padding(.horizontal).padding(.vertical, 12)
                  .foregroundColor(viewstore.activity.isSaturdayActive ? .white : .label)
              }
              .background(viewstore.activity.isSaturdayActive ? Color.green : Color.element)
              Divider()
              Button(action: { viewstore.send(.updateWeekend(.sun)) }) {
                Text("일요일")
                  .padding(.horizontal).padding(.vertical, 12)
                  .foregroundColor(viewstore.activity.isSundayActive ? .white : .label)
              }
              .background(viewstore.activity.isSundayActive ? Color.green : Color.element)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
          }
          Divider()
        }
        .padding(.leading)
      }
    }
  }
}

private struct ActivityInputViewIsActiveHandler: View {
  let viewstore: ViewStore<ActivityInputFeature.State, ActivityInputFeature.Action>
  
  var body: some View {
    VStack {
      Toggle("바로 시작하나요?", isOn: viewstore.binding(get: \.activity.isActive, send: ActivityInputFeature.Action.updateActive))
      
      if viewstore.activity.isActive {
        VStack {
          Divider()
          Toggle("오늘 시작할게요!", isOn: viewstore.binding(get: { $0.activeToday }, send: ActivityInputFeature.Action.updateActiveToday))
          Toggle("내일 시작할게요!", isOn: viewstore.binding(get: { !$0.activeToday }, send: ActivityInputFeature.Action.updateActiveToday))
          Divider()
        }
        .padding(.leading)
      }
    }
  }
}

private struct ActivityInputViewCompletionValueHandler: View {
  let viewstore: ViewStore<ActivityInputFeature.State, ActivityInputFeature.Action>
  
  var body: some View {
    VStack {
      Toggle("달성률을 체크하나요?", isOn: viewstore.binding(get: \.activity.completionUseSwitch, send: ActivityInputFeature.Action.updateUseSwitch))
      
      if viewstore.activity.completionUseSwitch {
        VStack {
          Divider()
          HStack(spacing: 16) {
            Text("횟수")
            Spacer()
            Text(String(viewstore.activity.completionCount))
            
            HStack(spacing: 0) {
              Button(action: { viewstore.send(.updateCount(false)) }) {
                Image(systemName: "minus").padding(.horizontal).padding(.vertical, 8)
              }
              Divider()
              Button(action: { viewstore.send(.updateCount(true)) }) {
                Image(systemName: "plus").padding(.horizontal).padding(.vertical, 8)
              }
            }
            .background(Color.element)
            .foregroundColor(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 8))
          }
          .alert(isPresented: Binding.constant(viewstore.countAlertPresented)) {
            Alert(
              title: Text("경고"),
              message: Text("0 아래의 값은 설정할 수 없습니다."),
              dismissButton: .cancel(Text("확인")) {
                viewstore.send(.showCountAlert)
              }
            )
          }
          
          HStack {
            Text("달성률 \(viewstore.activity.completionRatio)%")
            Slider(
              value: viewstore
                .binding(
                  get: {$0.activity.ratio},
                  send: {ActivityInputFeature.Action.updateSlider($0)}
                )
            )
          }
          
          Divider()
        }
        .padding(.leading)
      }
    }
  }
}

struct ActivityInputView_Previes: PreviewProvider {
  static var previews: some View {
    let initialStore = Store(
      initialState: ActivityInputFeature.State.init(activity: Activity.getDouble()),
      reducer: { ActivityInputFeature() })
    return ActivityInputView(store: initialStore)
  }
}
