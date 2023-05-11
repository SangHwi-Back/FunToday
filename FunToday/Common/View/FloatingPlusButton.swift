//
//  FloatingPlusButton.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/11.
//

import SwiftUI

struct FloatingPlusButton: View {
  let width: CGFloat
  let bgColor: Color
  let actionHandler: (() -> Void)?
  
  init(
    width: CGFloat,
    bgColor: Color = Color.blue,
    actionHandler: (() -> Void)? = nil) {
    
    self.width = width
    self.bgColor = bgColor
    self.actionHandler = actionHandler
  }
  
  var body: some View {
    ZStack(alignment: .center) {
      Rectangle().fill(Color.white)
        .frame(width: width / 3, height: width / 16)
      Rectangle().fill(Color.white)
        .frame(width: width / 16, height: width / 3)
    }
    .clipped()
    .frame(width: width, height: width)
    .background(bgColor.opacity(0.9))
    .cornerRadius(width / 2)
    .shadow(color: Color.shadow, radius: 3, x: 3, y: 3)
    .padding()
    .if(actionHandler != nil) { view in
      view.onTapGesture {
        actionHandler?()
      }
    }
  }
}

struct FloatingPlusButton_Previews: PreviewProvider {
  static var previews: some View {
    FloatingPlusButton(width: 70) {
      print("haha")
    }
  }
}
