//
//  GoalInsertView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/11.
//

import SwiftUI

struct GoalInsertView: View {
  @State var name: String = ""
  @State var desc: String = ""
  
  @State var routines: [Routine] = []
  @State var activeRoutine: Routine?
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) { VStack(spacing: 8) {
      VStack(spacing: 8) {
        
        // MARK: - Goal Section
        InputField(labels: [],
                   textField: CommonTextField(
                    title: "이름 :",
                    placeHolder: "(X)", text: $name))
        InputField(labels: [],
                   textField: CommonTextField(
                    title: "설명 :",
                    placeHolder: "(-)", text: $desc))
        
        // MARK: - Routines Section
        HStack {
          Text("루틴 \(routines.count)")
            .frame(maxWidth: .infinity, alignment: .leading)
          FloatingPlusButton(width: 18) {
            routines.append(Routine.getDouble(inx: routines.count))
          }
        }
        
        VStack(spacing: 8) {
          ForEach($routines) { routine in
            RoutineInputView(routine: routine)
          }
        }
      }}.padding()
    }
  }
}

struct RoutineInputView: View {
  @Binding var routine: Routine
  
  
  var body: some View {
    CustomSectionView() {
      VStack(spacing: 4) {
        InputField(labels: [],
                   textField: CommonTextField(
                    title: "이름 :",
                    placeHolder: "(X)", text: $routine.name))
        InputField(labels: [],
                   textField: CommonTextField(
                    title: "설명 :",
                    placeHolder: "(-)", text: $routine.description))
        
        // MARK: - Activities Section ( Inside of Routine)
        
        HStack {
          Text("활동")
            .frame(maxWidth: .infinity, alignment: .leading)
          FloatingPlusButton(width: 18) {
            routine.activities.append(Activity.getDouble(inx: routine.activities.count))
          }
        }
        
        ForEach($routine.activities) { activity in
          ActivityInputView(activity: activity)
        }
      }
    }
  }
}

struct ActivityInputView: View {
  private let dateFormatter: DateFormatter = {
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd"
    return format
  }()
  
  @Binding var activity: Activity
  @State var startDate: Date = Date() {
    didSet {
      activity.time_s = dateFormatter.string(from: startDate)
    }
  }
  @State var endDate: Date = Date() {
    didSet {
      activity.time_e = dateFormatter.string(from: startDate)
    }
  }
  @State var category = ActivityCategory.health
  
  var rangeDate = PartialRangeFrom<Date>(Date())
  
  var body: some View {
    CustomSectionView {
      VStack {
        InputField(labels: [],
                   textField: CommonTextField(
                    title: "이름 :",
                    placeHolder: "(X)", text: $activity.name))
        
        InputField(labels: [],
                   textField: CommonTextField(
                    title: "설명 :",
                    placeHolder: "(-)", text: $activity.description))
        
        HStack {
          Text("카테고리")
          Picker("종류", selection: $category) {
            ForEach(ActivityCategory.allCases, id: \.rawValue) { category in
              Text(String(describing: category))
                .tag(category)
            }
          }
          .frame(maxWidth: .infinity)
        }
        
        HStack {
          Text("기간")
          DatePicker("", selection: $startDate, displayedComponents: [.date])
          Text(" ~ ")
          DatePicker("", selection: $endDate, displayedComponents: [.date])
        }
        
        Toggle("매일 진행하나요?", isOn: $activity.isDailyActive)
        Toggle("주말에도 진행하나요?", isOn: $activity.isWeekendActive)
        Toggle("바로 시작하나요?", isOn: $activity.isActive)
        Toggle("달성률을 체크하나요?", isOn: $activity.completionUseSwitch)
      }
    }
  }
}

struct GoalInsertView_Previews: PreviewProvider {
  static var previews: some View {
    GoalInsertView()
  }
}
