//
//  ReviewView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI

struct ReviewView: View {
  @EnvironmentObject var db: DependencyFirebaseDB
  
  var body: some View {
    GeometryReader { proxy in
      VStack(alignment: .center, spacing: 8) {
        HStack(alignment: .center, spacing: 24) {
          ProgressCircle(status: Binding.constant(ProgressStatus.getDouble()))
          ProgressCircle(status: Binding.constant(ProgressStatus.getDouble()))
        }
        .padding(.horizontal)
        
        CustomTable([Goal.getDouble()]) { goal in
          [
            CustomTableColumn(title: "운동", value: \.name),
            CustomTableColumn(title: "공부", value: \.name),
          ]
        }
      }
    }
  }
}

struct ReviewView_Previews: PreviewProvider {
  static var previews: some View {
    ReviewView()
  }
}
