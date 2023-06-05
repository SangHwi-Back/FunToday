//
//  ReviewView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI

struct ReviewView: View {
  
  @State var currentSelectedPeriod: ReviewViewState = .today
  @State var goals: [Goal] = GoalStore.DP.loadAll().compactMap {
    try? JSONDecoder().decode(Goal.self, from: $0)
  }
  @State var currentGoal: Goal? = {
    var goal = Goal.getDouble()
    var routine = Routine.getDouble()
    routine.activities = [Activity.getDouble(inx: 0), Activity.getDouble(inx: 1), Activity.getDouble(inx: 2)]
    goal.routines = [routine]
    goal.activeRoutine = routine
    return goal
  }()
  var currentCategories: [ActivityCategory] {
    guard let goal = currentGoal?.activeRoutine else { return [] }
    return goal.activities.compactMap({ $0.category })
  }
  
  var body: some View {
    VStack(spacing: 8) {
      ProgressCircle(
        status: Binding.constant(
          ProgressStatus(value: 0.7, color: .blue, text: "현재 달성률")))
      .padding(.top)
      
      CustomSectionView {
        ScrollView(.horizontal) {
          HStack {
            ForEach(currentCategories) { category in
              VStack {
                ProgressCircle(status: Binding.constant(ProgressStatus(value: CGFloat.random(in: 0.0...1.0), color: category.color, text: "")))
                Text(String(describing: category))
                  .minimumScaleFactor(0.2)
                  .font(.caption)
              }
              .padding(.trailing)
            }
          }
        }
      }
      .frame(height: 120)
      .padding()
      
      ReviewViewMainRoutineView(currentGoal: $currentGoal)
        .padding()
      
      ReviewMainController(goals: $goals, currentGoal: $currentGoal)
        .padding()
    }
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarTitle(Text(currentGoal?.name ?? "none"))
  }
}

struct ReviewView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView { ReviewView() }
  }
}
