//
//  CommonPushButtonStyle.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/04.
//

import SwiftUI

struct CommonPushButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(Color.white)
      .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
      .background(Color.blue.opacity(0.8))
      .clipShape(Capsule(style: .continuous))
  }
}
