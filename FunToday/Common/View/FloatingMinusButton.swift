//
//  FloatingMinusButton.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/12.
//

import SwiftUI

struct FloatingMinusButton: View {
  let width: CGFloat
  let bgColor: Color
  let actionHandler: (() -> Void)?
  
  init(
    width: CGFloat,
    bgColor: Color = Color.red,
    actionHandler: (() -> Void)? = nil) {
      
      self.width = width
      self.bgColor = bgColor
      self.actionHandler = actionHandler
    }
  
  var body: some View {
    ZStack(alignment: .center) {
      Rectangle().fill(Color.white)
        .frame(width: width / 2, height: width / 16)
        .rotationEffect(Angle.degrees(135))
      Rectangle().fill(Color.white)
        .frame(width: width / 16, height: width / 2)
        .rotationEffect(Angle.degrees(-45))
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

struct FloatingMinusButton_Previews: PreviewProvider {
  static var previews: some View {
    FloatingMinusButton(
      width: 50,
      bgColor: Color.red)
  }
}
