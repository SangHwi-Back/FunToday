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
        ScrollView(showsIndicators: false) {
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
              .scaledToFit()
            Text("~")
            DatePicker("", selection: viewstore.binding(get: \.endDate, send: ActivityInputFeature.Action.updateEndDate), displayedComponents: [.hourAndMinute])
              .scaledToFit()
          }
          .padding(.vertical, 4)
          
          ActivityInputViewDailyHandler(viewstore: viewstore)
            .padding(4)
          ActivityInputViewWeekendHandler(viewstore: viewstore)
            .padding(4)
          ActivityInputViewIsActiveHandler(viewstore: viewstore)
            .padding(4)
          ActivityInputViewCompletionValueHandler(viewstore: viewstore)
            .padding([.horizontal, .top], 4)
            .padding(.bottom)
        }
      }
      .onTapGesture { hideKeyboard() }
      .minimumScaleFactor(0.2)
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
          ForEach(Activity.Weekday.allCases) { weekday in
            getButton(weekday: weekday) { viewstore.send(.updateWeekDay(weekday)) }
            Divider()
          }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
      }
    }
  }
  
  private func getButton(weekday: Activity.Weekday, action: @escaping ()->Void) -> some View {
    let isActive = viewstore.activity.isActive(weekday: weekday)
    return Button(weekday.name, action: action)
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
              ForEach(Activity.Weekend.allCases) { weekend in
                getButton(weekend: weekend) { viewstore.send(.updateWeekend(weekend)) }
                Divider()
              }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
          }
        }
        .padding(.leading)
      }
    }
  }
  
  private func getButton(weekend: Activity.Weekend, action: @escaping ()->Void) -> some View {
    let isActive = viewstore.activity.isActive(weekend: weekend)
    return Button(weekend.name, action: action)
      .padding(.horizontal).padding(.vertical, 12)
      .scaledToFill()
      .foregroundColor(isActive ? .white : .label)
      .background(isActive ? Color.green : Color.element)
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
  let viewstore: ViewStoreOf<ActivityInputFeature>
  
  var body: some View {
    VStack {
      Text("달성률을...")
        .frame(maxWidth: .infinity, alignment: .leading)
      
      HStack {
        Toggle("횟수로", isOn: viewstore.binding(
          get: { $0.completionAs == .count },
          send: { ActivityInputFeature.Action.completionAsTapped($0 ? .count : nil) }))
        Spacer()
        Toggle("%로", isOn: viewstore.binding(
          get: { $0.completionAs == .slider },
          send: { ActivityInputFeature.Action.completionAsTapped($0 ? .slider : nil) }))
      }
      
      if let completionAs = viewstore.completionAs {
        VStack {
          Divider()
          
          switch completionAs {
          case .count: CountView(viewstore: viewstore)
          case .slider: SliderView(viewstore: viewstore)
          }
          
          Divider()
        }
        .padding(.leading)
      }
    }
  }
  
  struct CountView: View {
    let viewstore: ViewStoreOf<ActivityInputFeature>
    
    var body: some View {
      HStack(spacing: 16) {
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
    }
  }
  
  struct SliderView: View {
    let viewstore: ViewStoreOf<ActivityInputFeature>
    
    var body: some View {
      HStack {
        Text("\(viewstore.activity.completionRatio)%")
        Slider(value: viewstore.binding(get: \.activity.ratio, send: ActivityInputFeature.Action.updateSlider)) {
          Text("\(viewstore.activity.ratio)%")
        }
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
