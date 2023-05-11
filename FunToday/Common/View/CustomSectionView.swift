//
//  CustomSectionView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/11.
//

import SwiftUI

struct CustomSectionView<ContentsView: View>: View {
  
  var title: String?
  var contents: () -> ContentsView
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 8)
        .strokeBorder(Color.border, lineWidth: 2, antialiased: false)
      VStack(spacing: 8) {
        if let title {
          Text(title)
            .font(Font.title)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        contents()
      }
      .padding()
    }
  }
}

struct CustomSection_Previews: PreviewProvider {
  static var previews: some View {
    CustomSectionView(title: "루틴",
                  contents: {
      InputField(labels: [],
                 textField: CommonTextField(title: "이름", placeHolder: "X", text: Binding.constant("")))
    })
      .padding()
  }
}
