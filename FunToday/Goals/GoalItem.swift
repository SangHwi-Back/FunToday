//
//  GoalItem.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI

struct GoalItem<ContentsView: View>: View {
  
  @State var isFold = true
  
  var rgbColor: Color
  var size: CGSize
  var contentsView: () -> ContentsView
  private var chevronImageName: String {
    isFold ? "chevron.compact.down" : "chevron.compact.up"
  }
  private var bottomViewHeight: CGFloat {
    isFold ? 18 : 240
  }
  
  init(rgbColor: Color, size: CGSize, _ contentsView: @escaping () -> ContentsView) {
    self.rgbColor = rgbColor
    self.size = size
    self.contentsView = contentsView
  }
  
  var body: some View {
    ZStack {
      ZStack {
        RoundedRectangle(cornerRadius: 8)
          .fill(Color.element)
          .cornerRadius(12)
          .northWestShadow()
      }
      ZStack {
        
        RoundedRectangle(cornerRadius: 8)
          .fill(rgbColor)
        
        VStack(spacing: 8) {
          contentsView()
            .padding(8)
          
          Spacer()
          
          ZStack {
            RoundedRectangle(cornerRadius: 8)
              .fill(Color.highlight)
            VStack {
              if isFold {
                Image(systemName: chevronImageName)
              }
              else {
                VStack(spacing: 8) {
                  Image(systemName: chevronImageName)
                    .padding(.top, 8)
                  Spacer()
                  HStack {
                    ProgressCircle(
                      value: Binding.constant(CGFloat(0.5)),
                      mainColor: Binding.constant(Color.element),
                      contentsHandler: Binding.constant({
                        Text("운동")
                      })
                    )
                    ProgressCircle(
                      value: Binding.constant(CGFloat(0.7)),
                      mainColor: Binding.constant(Color.element),
                      contentsHandler: Binding.constant({
                        Text("공부")
                      })
                    )
                  }
                  CustomTable<Routine, Any>(
                    titles: ["50%", "70%"],
                    rows: Binding.constant([])
                  )
                  .padding(.horizontal, 8)
                }
              }
            }
          }
          .frame(height: bottomViewHeight)
          .onTapGesture { isFold.toggle() }
        }
      }
      .padding(8)
    }
    .frame(width: size.width,
           height: size.height + bottomViewHeight)
    .animation(.easeOut(duration: 0.2), value: isFold)
  }
}

struct GoalItem_Previews: PreviewProvider {
  static var previews: some View {
    GoalItem(
      rgbColor: Color.red.opacity(0.2),
      size: CGSize(width: 300, height: 120)) {
        Text("Hello There!")
      }
  }
}
