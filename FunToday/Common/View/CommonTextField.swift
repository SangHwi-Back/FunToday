//
//  CommonTextField.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/11.
//

import SwiftUI

struct CommonTextField: View {
  
  let capImage: Image?
  let isSecure: Bool
  let placeHolder: String
  
  @Binding var text: String
  
  init(
    capImage: Image? = nil,
    isSecure: Bool = false,
    placeHolder: String,
    text: Binding<String>
  ) {
    self.capImage = capImage
    self.isSecure = isSecure
    self.placeHolder = placeHolder
    self._text = text
  }
  
  var body: some View {
    ZStack {
      HStack {
        if let capImage {
          capImage.frame(width: 20, height: 20)
        }
        
        if isSecure {
          SecureField(placeHolder, text: $text).font(.subheadline)
        } else {
          TextField(placeHolder, text: $text).font(.subheadline)
        }
      }
      .padding(.horizontal, 8)
      .padding(.vertical, 16)
    }
    .background(Color.element)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    
  }
}

struct CommonTextField_Previews: PreviewProvider {
  @State static var value: String = ""
  
  static var previews: some View {
    CommonTextField(
      capImage: Image(systemName: "person"),
      placeHolder: "Test", text: $value)
    .frame(height: 80)
  }
}
