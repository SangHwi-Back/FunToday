//
//  DescriptionText.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/11.
//

import SwiftUI

struct DescriptionText: View, Identifiable {
  var id: UUID = .init()
  
  private let text: String
  private let isBold: Bool
  
  private var customFont: UIFont {
    isBold
    ? UIFont.boldSystemFont(ofSize: 15)
    : UIFont.preferredFont(forTextStyle: .footnote)
  }
  
  init(
    text: String,
    isBold: Bool = false
  ) {
    self.text = text
    self.isBold = isBold
  }
  
  var body: some View {
    Text(text)
      .font(Font(customFont))
  }
}

struct DescriptionText_Previews: PreviewProvider {
  static var previews: some View {
    DescriptionText(text: "Test", isBold: true)
  }
}
