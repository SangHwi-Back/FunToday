//
//  ProgressCircle.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/04.
//

import SwiftUI

struct ProgressCircle: View {
  
  @Binding var status: ProgressStatus
  
  var body: some View
  { ZStack {
    Circle()
      .opacity(0.3)
      .foregroundColor(status.color)
    
    Circle()
      .trim(from: 0.0, to: status.value)
      .rotation(Angle.degrees(-90))
      .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
      .padding(4)
      .foregroundColor(status.color)
    
    Text(status.text)
  }.aspectRatio(contentMode: .fill)
  }
}

struct ProgressStatus {
  var value: CGFloat
  var color: Color
  var text: String
}

extension ProgressStatus: TestDouble {
  static func getDouble(inx: Int = 0) -> ProgressStatus {
    return .init(value: 5, color: Color.element, text: "50%")
  }
}

struct ProgressCircle_Previews: PreviewProvider {
  static var previews: some View {
    ProgressCircle(status: Binding.constant(ProgressStatus.getDouble()))
  }
}
