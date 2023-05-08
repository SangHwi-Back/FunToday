//
//  CommonRectangle.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/08.
//

import SwiftUI

struct CommonRectangle: View {
  @Binding var color: Color
  var body: some View {
    RoundedRectangle(cornerRadius: 8)
      .fill(color)
  }
}
