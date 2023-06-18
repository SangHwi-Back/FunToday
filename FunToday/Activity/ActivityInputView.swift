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
          InputField(title: "이름 :",
                     isEssential: true,
                     text: viewstore.binding(
                      get: \.activity.name,
                      send: ActivityInputFeature.Action.updateName))
          InputField(title: "설명 :",
                     isEssential: false,
                     text: viewstore.binding(
                      get: \.activity.description,
                      send: ActivityInputFeature.Action.updateDescription))
          
          HStack(spacing: 12) {
            Text("카테고리")
            Picker("종류", selection: viewstore.binding(
              get: \.activity.category,
              send: ActivityInputFeature.Action.updateCategory)) {
                ForEach(Activity.Category.allCases, id: \.id) { category in
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
            DatePicker("기간",
                       selection: Binding(
                        get: { viewstore.activity.startDate },
                        set: { viewstore.send(.updateDate(.start, $0)) }),
                       displayedComponents: [.hourAndMinute])
            DatePicker("~",
                       selection: Binding(
                        get: { viewstore.activity.endDate },
                        set: { viewstore.send(.updateDate(.end, $0)) }),
                       displayedComponents: [.hourAndMinute])
            .scaledToFit()
          }
          .padding(.vertical, 4)
          .commonAlert(isPresented: Binding.constant(viewstore.alertState.greaterThanStartDate),
                       msg: "종료 시간을 시작 시간 이후로 설정해주시기 바랍니다.",
                       action: {
            viewstore.send(.showAlert(\.greaterThanStartDate))
          })
          .commonAlert(isPresented: Binding.constant(viewstore.alertState.lessThanEndDate),
                       msg: "시작 시간을 종료 시간 이후로 설정해주시기 바랍니다.",
                       action: {
            viewstore.send(.showAlert(\.lessThanEndDate))
          })
          
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
      .navigationTitle(viewstore.routineDateTitle)
    }
  }
}

private struct ActivityInputViewDailyHandler: View {
  let viewstore: ViewStore<ActivityInputFeature.State, ActivityInputFeature.Action>
  
  var body: some View {
    VStack {
      Toggle("매일 진행하나요?", isOn: viewstore.binding(
        get: \.activity.isDailyActive,
        send: ActivityInputFeature.Action.updateViewActive(.dailySchedule)))
      
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
      Toggle("주말에도 진행하나요?", isOn: viewstore.binding(
        get: \.activity.isWeekendActive,
        send: ActivityInputFeature.Action.updateViewActive(.weekendSchedule)))
      
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
      Toggle("바로 시작하나요?", isOn: viewstore.binding(
        get: \.activity.isActive,
        send: ActivityInputFeature.Action.updateViewActive(.startNowOrTomorrow)))
      
      if viewstore.activity.isActive {
        VStack {
          Divider()
          Toggle("오늘 시작할게요!", isOn: viewstore.binding(
            get: { $0.activeToday },
            send: ActivityInputFeature.Action.updateActiveStart))
          Toggle("내일 시작할게요!", isOn: viewstore.binding(
            get: { !$0.activeToday },
            send: ActivityInputFeature.Action.updateActiveStart))
          Divider()
        }
        .padding(.leading)
      }
    }
  }
}

private struct ActivityInputViewCompletionValueHandler: View {
  let viewstore: ViewStoreOf<ActivityInputFeature>
  
  var viewName: String {
    if viewstore.isNew {
      return "달성률을..."
    }
    else if viewstore.completionAs == nil {
      return "달성률 체크 안함"
    }
    else {
      return "달성률 체크"
    }
  }
  
  var body: some View {
    VStack {
      Text(viewName)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      if viewstore.isNew {
        HStack {
          Toggle("횟수로", isOn: viewstore.binding(
            get: { $0.completionAs == .count },
            send: { ActivityInputFeature.Action.completionSwitchTapped($0 ? .count : nil) }))
          Spacer()
          Toggle("%로", isOn: viewstore.binding(
            get: { $0.completionAs == .slider },
            send: { ActivityInputFeature.Action.completionSwitchTapped($0 ? .slider : nil) }))
        }
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
        if viewstore.isNew {
          Text("\(viewstore.activity.completionCount)")
            .font(.title)
        }
        else {
          Text("\(viewstore.activity.countCompletion)")
            .font(.title)
          Text("/ \(viewstore.activity.completionCount)")
            .font(.headline)
            .frame(alignment: .centerLastTextBaseline)
        }
        
        HStack(spacing: 0) {
          Button(action: { viewstore.send(.updateCount(false)) }) {
            Image(systemName: "minus").padding(.horizontal).padding(.vertical, 8)
          }
          .commonAlert(isPresented: Binding.constant(viewstore.alertState.lessThanZeroCount),
                       msg: "0 아래의 값은 설정할 수 없습니다.",
                       action: {
            viewstore.send(.showAlert(\.lessThanZeroCount))
          })
          Divider()
          Button(action: { viewstore.send(.updateCount(true)) }) {
            Image(systemName: "plus").padding(.horizontal).padding(.vertical, 8)
          }
          .commonAlert(isPresented: Binding.constant(viewstore.alertState.exeededCount),
                       msg: "최대 횟수를 초과하였습니다. 활동 추가하기 창에서 최대 횟수를 바꿀 수 있습니다.",
                       action: {
            viewstore.send(.showAlert(\.exeededCount))
          })
        }
        .background(Color.element)
        .foregroundColor(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 8))
      }
    }
  }
  
  struct SliderView: View {
    let viewstore: ViewStoreOf<ActivityInputFeature>
    
    var body: some View {
      HStack {
        Text("\(Int(viewstore.currentRatio * 100))%")
        Slider(value: viewstore.binding(
          get: \.currentRatio,
          send: ActivityInputFeature.Action.updateSlider)
        ) {
          Text("\(viewstore.currentRatio)%")
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

private extension View {
  func commonAlert(isPresented: Binding<Bool>, msg: String, action: (() -> Void)?) -> some View {
    modifier(ActivityInputViewAlertModifier(showAlert: isPresented, message: msg, action: action))
  }
}

private struct ActivityInputViewAlertModifier: ViewModifier {
  @Binding var showAlert: Bool
  let message: String
  let action: (()->Void)?
  func body(content: Content) -> some View {
    content
      .alert(isPresented: $showAlert) {
        Alert(
          title: Text("경고"),
          message: Text(message),
          dismissButton: .cancel(Text("확인"), action: action))
      }
  }
}
