//
//  GoalItem.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI

struct GoalItem<ContentsView: View>: View {
  
  @Binding private var goal: Goal
  
  var size: CGSize
  var contentsView: () -> ContentsView
  private var chevronImageName: String {
    goal.isFold ? "chevron.compact.down" : "chevron.compact.up"
  }
  
  init(goal: Binding<Goal>,
       size: CGSize, _ contentsView: @escaping () -> ContentsView) {
    self._goal = goal
    self.size = size
    self.contentsView = contentsView
  }
  
  var body: some View
  { ZStack {
    CommonRectangle(color: Binding.constant(Color.element))
      .northWestShadow()
    
    ZStack {
      CommonRectangle(color: Binding.constant(Color.cell))
      
      VStack(spacing: 8) {
        contentsView().padding(8)
        
        VStack(spacing: 8) {
          Image(systemName: chevronImageName)
            .padding(.top, goal.isFold ? 0 : 8)
            .foregroundColor(Color.element)
          
          if goal.isFold == false {
            HStack {
              ProgressCircle(status: Binding.constant(ProgressStatus.getDouble()))
              ProgressCircle(status: Binding.constant(ProgressStatus.getDouble()))
            }
            
            CustomTable([goal]) { goal in
              [
                CustomTableColumn(title: "운동", value: \.name),
                CustomTableColumn(title: "공부", value: \.name),
              ]
            }
          }
        }
        .frame(width: size.width)
        .frame(minHeight: 18)
        .background(Color.highlight)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .onTapGesture { goal.isFold.toggle() }
      }
    }.padding(8)
  }
  .frame(width: size.width)
  .animation(.easeOut(duration: 0.2), value: goal.isFold)
  }
}

struct GoalItem_Previews: PreviewProvider {
  static var previews: some View {
    GoalItem(
      goal: Binding.constant(Goal.getDouble()),
      size: CGSize(width: 300, height: 120)) {
        Text("Hello There!")
      }
  }
}
