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
        
        Text("활동")
          .frame(maxWidth: .infinity, alignment: .leading)
        
        NavigationLink { ActivityInputContainer(activities: $routine.activities) } label: {
          Text("Put some Input activities")
        }
      }
    }
  }
}

struct RoutineInputView_Preview: PreviewProvider {
  static var previews: some View {
    RoutineInputView(routine: .constant(Routine.getDouble()))
  }
}
