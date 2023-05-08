//
//  GoalsView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI

struct GoalsView: View {
  
  @State var goals: [Goal] = [
    Goal.getDouble(inx: 0), Goal.getDouble(inx: 1),
    Goal.getDouble(inx: 2), Goal.getDouble(inx: 3),
    Goal.getDouble(inx: 4), Goal.getDouble(inx: 5),
    Goal.getDouble(inx: 6), Goal.getDouble(inx: 7),
    Goal.getDouble(inx: 8), Goal.getDouble(inx: 9),
  ]
  
  var body: some View {
    GeometryReader { proxy in
      NavigationView {
        ScrollView {
          LazyVStack
          {
            ForEach($goals, id: \.index) { $goal in
              NavigationLink {
                GoalDetail()
              } label: {
                GoalItem(
                  goal: $goal,
                  size: CGSize(width: proxy.size.width - 16, height: 120)) {
                    VStack {
                      // TODO: Binding 혹은 constant 한 Range 만을 써야하므로 오류가 발생하고 있음. 수정 예정.
                      ForEach(0..<Int.random(in: 1...5)) {_ in
                        Text("Hello World")
                      }
                    }
                  }
              }
              .navigationBarHidden(true)
            }
          }
        }
      }
      .padding(.vertical, 0.1)
    }
  }
}
struct GoalsView_Previews: PreviewProvider {
  static var previews: some View {
    GoalsView()
  }
}
