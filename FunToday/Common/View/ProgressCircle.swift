//
//  ProgressCircle.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/04.
//

import SwiftUI

struct ProgressCircle<ContentsView>: View where ContentsView: View {
  
  @Binding var value: CGFloat
  
  @Binding var mainColor: Color
  @Binding var contentsHandler: () -> ContentsView
  
  var body: some View
  { ZStack {
    Circle()
      .opacity(0.3)
      .foregroundColor(mainColor)
    
    Circle()
      .trim(from: 0.0, to: value)
      .rotation(Angle.degrees(-90))
      .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
      .padding(4)
      .foregroundColor(mainColor)
    
    contentsHandler()
  }}
}

struct ProgressCircle_Previews: PreviewProvider {
  static var previews: some View {
    ProgressCircle<Button<Text>>(
      value: Binding.constant(CGFloat(0.9)),
      mainColor: Binding.constant(Color.red),
      contentsHandler: Binding.constant({
        Button {
          print("testing")
        } label: {
          Text("90%")
        }
      }))
    .buttonStyle(CommonPushButtonStyle())
  }
}
