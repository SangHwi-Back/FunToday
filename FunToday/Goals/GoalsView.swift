//
//  GoalsView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI

struct GoalsView: View {
  var body: some View {
    GeometryReader { proxy in
      NavigationView {
        ScrollView {
          LazyVStack
          {
            ForEach(0..<20) { inx in
              NavigationLink {
                GoalDetail()
              } label: {
                GoalItem(
                  rgbColor: Color.red.opacity(0.2),
                  size: CGSize(width: proxy.size.width - 16, height: 120))
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
