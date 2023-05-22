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
      ScrollView(.vertical, showsIndicators: false) {
        CustomSectionView {
          VStack(spacing: 4) {
            InputField(title: "이름 :", isEssential: true,
                       text: viewstore.binding(get: \.activity.name, send: ActivityInputFeature.Action.updateName))
            InputField(title: "설명 :", isEssential: false,
                       text: viewstore.binding(get: \.activity.description, send: ActivityInputFeature.Action.updateDescription))
            
            HStack {
              Text("카테고리")
              Picker("종류", selection: viewstore.binding(get: \.category, send: ActivityInputFeature.Action.updateCategory)) {
                ForEach(ActivityCategory.allCases, id: \.rawValue) { category in
                  Text(String(describing: category))
                    .tag(category)
                }
              }
              .frame(maxWidth: .infinity)
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
            
            Toggle("매일 진행하나요?", isOn: viewstore.binding(get: \.activity.isDailyActive, send: ActivityInputFeature.Action.updateDailyActive))
            Toggle("주말에도 진행하나요?", isOn: viewstore.binding(get: \.activity.isWeekendActive, send: ActivityInputFeature.Action.updateWeekendActive))
            Toggle("바로 시작하나요?", isOn: viewstore.binding(get: \.activity.isActive, send: ActivityInputFeature.Action.updateActive))
            Toggle("달성률을 체크하나요?", isOn: viewstore.binding(get: \.activity.completionUseSwitch, send: ActivityInputFeature.Action.updateUseSwitch))
          }
        }
      }
    }
  }
}

//struct ActivityInputView_Previes: PreviewProvider {
//  static var previews: some View {
//    ActivityInputView(activity: Binding.constant(Activity.getDouble()))
//  }
//}

struct ActivityInputFeature: ReducerProtocol {
  
  struct State: Equatable, Identifiable {
    var id: UUID = .init()
    var activity: Activity
    
    let dateFormatter: DateFormatter = {
      let format = DateFormatter()
      format.dateFormat = "yyyy-MM-dd"
      return format
    }()
    
    var startDate: Date = Date()
    var endDate: Date = Date()
    var category = ActivityCategory.health
  }
  
  enum Action {
    case updateName(String)
    case updateDescription(String)
    case updateCategory(ActivityCategory)
    case updateStartDate(Date)
    case updateEndDate(Date)
    case updateDailyActive
    case updateWeekendActive
    case updateActive
    case updateUseSwitch
    case removeActivity
    case buttonTapped(id: State.ID, buttontype: ActivityHeaderButtonType)
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .updateName(let txt):
      state.activity.name = txt
      return .none
    case .updateDescription(let txt):
      state.activity.description = txt
      return .none
    case .updateCategory(let category):
      state.activity.categoryValue = category.rawValue
      return .none
    case .updateStartDate(let date):
      state.activity.time_s = state.dateFormatter.string(from: date)
      return .none
    case .updateEndDate(let date):
      state.activity.time_e = state.dateFormatter.string(from: date)
      return .none
    case .updateDailyActive:
      state.activity.isDailyActive.toggle()
      return .none
    case .updateWeekendActive:
      state.activity.isWeekendActive.toggle()
      return .none
    case .updateActive:
      state.activity.isActive.toggle()
      return .none
    case .updateUseSwitch:
      state.activity.completionUseSwitch.toggle()
      return .none
    case .removeActivity:
      return .none
    case .buttonTapped:
      return .none
    }
  }
  
  enum ActivityHeaderButtonType {
    case basic, minus
  }
}
