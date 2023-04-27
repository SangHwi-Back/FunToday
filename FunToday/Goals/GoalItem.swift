//
//  GoalItem.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI

struct GoalItem: View {
  var rgbColor: Color
  var size: CGSize
  
  var body: some View {
    ZStack {
      Rectangle()
        .fill(Color.element)
        .cornerRadius(12)
        .northWestShadow()
      Rectangle().cornerRadius(8)
        .padding(8)
        .cornerRadius(12)
        .foregroundColor(rgbColor)
    }
    .frame(width: size.width, height: size.height)
  }
}

struct GoalItem_Previews: PreviewProvider {
  static var previews: some View {
    GoalItem(
      rgbColor: Color.red.opacity(0.2),
      size: CGSize(width: 300, height: 120)
    )
  }
}
