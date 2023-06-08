//
//  View+ResignFirstResponder.swift
//  FunToday
//
//  Created by 백상휘 on 2023/06/08.
//

import SwiftUI

extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
