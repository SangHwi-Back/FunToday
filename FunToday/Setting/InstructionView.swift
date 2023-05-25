//
//  InstructionView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/25.
//

import SwiftUI
import ComposableArchitecture

struct InstructionView: View {
  var body: some View {
    GeometryReader { geometryproxy in
      ScrollView {
        Text("Hello InstructionView")
          .frame(width: geometryproxy.size.width)
          .padding()
      }
    }
  }
}
