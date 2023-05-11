//
//  GoalsView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI

struct GoalsView: View {
  
  @State var goals: [Goal] = [
    Goal.getDouble(inx: 0)
  ]
  
  var body: some View {
    GeometryReader { proxy in
      NavigationView {
        ZStack {
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
                      VStack(alignment: .leading, spacing: 8) {
                        Text(goal.name)
                          .frame(maxWidth: .infinity, alignment: .leading)
                          .font(Font.title)
                        
                        Text(goal.description)
                          .lineLimit(3)
                          .truncationMode(.tail)
                          .font(Font.subheadline)
                        
                        Label(goal.timeFromTo, systemImage: "calendar")
                          .frame(maxWidth: .infinity, alignment: .trailing)
                          .font(Font.caption)
                      }
                      .fixedSize(horizontal: false, vertical: true)
                      .foregroundColor(Color.label)
                    }
                }
                .navigationBarHidden(true)
              }
            }
          } // EO ScrollView
          
          FloatingPlusButton(width: proxy.size.width / 6) {
            goals.append(Goal.getDouble(inx: goals.count))
          }
        }
      } // EO NavigationView
      .padding(.vertical, 0.1)
    } // EO GeomeryReader
  }
}
struct GoalsView_Previews: PreviewProvider {
  static var previews: some View {
    GoalsView()
  }
}
