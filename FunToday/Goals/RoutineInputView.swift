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
        InputField(title: "이름 :", isEssential: true, text: $routine.name)
        InputField(title: "설명 :", isEssential: false, text: $routine.description)
        
        // MARK: - Activities Section ( Inside of Routine)
        
        HStack {
          Text("활동")
            .frame(maxWidth: .infinity, alignment: .leading)
          FloatingPlusButton(width: 24, bgColor: .gray) {
            routine.activities.append(Activity.getDouble(inx: routine.activities.count))
          }
        }
        
        VStack(spacing: 8) {
          ForEach($routine.activities) { activity in
            ActivityInputView(activity: activity)
          }
        }
      }
    }
  }
}
