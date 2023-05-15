//
//  DottedLine.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/15.
//

import SwiftUI

struct DottedLine: View {
  var from: CGPoint = .zero
  var to: CGPoint = CGPoint(x: 0, y: 40)
  var width: CGFloat = 2
  
  var body: some View {
    Path { path in
      path.move(to: from)
      path.addLine(to: to)
    }
    .stroke(Color.secondary, style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round, dash: [1,4]))
    .frame(width: width)
    .padding(.horizontal)
  }
}
