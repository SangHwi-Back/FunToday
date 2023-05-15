//
//  CommonBarChart.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/15.
//

import SwiftUI

struct CommonBarChart<V: Comparable & Identifiable>: View {
  var data: [V]
  var spacing: CGFloat = 4
  var barWidthHandler: (V) -> CGFloat
  var sort: (V, V) -> Bool = { $0 < $1 }
  var barColorHandler: (V) -> Color = { _ in .secondary }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      ForEach(data.sorted(by: sort)) { v in
        Rectangle()
          .fill(barColorHandler(v))
          .frame(width: barWidthHandler(v))
      }
    }
  }
}
