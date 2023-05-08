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
                  rgbColor: Color.cell,
                  size: CGSize(width: proxy.size.width - 16, height: 120)) {
                    Text("Hello World")
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
