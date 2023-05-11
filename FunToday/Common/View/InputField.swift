//
//  InputField.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/11.
//

import SwiftUI

struct InputField: View {
  let labels: [DescriptionText]
  let textField: CommonTextField
  
  @State var isFineText = false
  
  init(
    labels: [DescriptionText],
    textField: CommonTextField
  ) {
    self.labels = labels
    self.textField = textField
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      textField
      ForEach(labels) { label in
        label
      }
    }
  }
}

struct InputField_Previews: PreviewProvider {
  static var previews: some View {
    InputField(labels: [
      DescriptionText(text: "Test", isBold: true),
      DescriptionText(text: "Test", isBold: true)
    ], textField: CommonTextField(
      placeHolder: "Email",
      text: .constant("test@gmail.com")
    ))
  }
}
