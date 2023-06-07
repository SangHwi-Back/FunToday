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
      .navigationBarTitleDisplayMode(.inline)
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
