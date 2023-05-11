//
//  View+If.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/11.
//

import SwiftUI

extension View {
  @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }
}
