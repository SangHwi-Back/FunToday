//
//  ReviewView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI

struct ReviewView: View {
  
  @State var goals: [Goal] = []
  var currentGoal: Goal? {
    goals.first
  }
  
  var body: some View {
    VStack(spacing: 8) {
      ProgressCircle(ProgressStatus(value: 0.7, color: .blue))
        .frame(height: 150)
        .padding(.top)
      
      ReviewViewMainRoutineView(goals: $goals, currentGoal: currentGoal)
        .padding()
      
      ReviewMainController(goals: $goals, currentGoal: currentGoal)
        .padding(.horizontal)
        .padding(.bottom)
    }
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarTitle(Text(goals.first?.name ?? "none"))
    .onAppear {
      goals = GoalStore.DP
        .loadAll()
        .compactMap { try? JSONDecoder().decode(Goal.self, from: $0) }
    }
  }
}

struct ReviewView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView { ReviewView() }
  }
}
