//
//  RoutineInputView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/11.
//

import SwiftUI

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
