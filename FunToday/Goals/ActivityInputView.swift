//
//  ActivityInputView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/11.
//

import SwiftUI

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
      VStack(spacing: 4) {
        InputField(title: "이름 :", isEssential: true, text: $activity.name)
        InputField(title: "설명 :", isEssential: false, text: $activity.description)
        
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
        .padding(.vertical, 4)
        
        HStack {
          DatePicker("", selection: $startDate, displayedComponents: [.date])
          Text("~")
          DatePicker("", selection: $endDate, displayedComponents: [.date])
        }
        .padding(.vertical, 4)
        
        Toggle("매일 진행하나요?", isOn: $activity.isDailyActive)
        Toggle("주말에도 진행하나요?", isOn: $activity.isWeekendActive)
        Toggle("바로 시작하나요?", isOn: $activity.isActive)
        Toggle("달성률을 체크하나요?", isOn: $activity.completionUseSwitch)
      }
    }
  }
}
