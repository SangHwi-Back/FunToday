//
//  ReviewViewMainRoutineView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/06/05.
//

import SwiftUI

struct ReviewViewMainRoutineView: View {
  @Binding var currentGoal: Goal?
  
  var body: some View {
    ScrollView {
      VStack(spacing: 8) {
        if let routines = currentGoal?.routines {
          ForEach(routines) { routine in
            ForEach(routine.activities) { activity in
              VStack(spacing: 8) {
                Text(activity.name)
                  .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                HStack {
                  Text(activity.time_s.split(separator: "-").last ?? "0")
                    .frame(maxWidth: 20)
                    .minimumScaleFactor(0.2)
                    .font(.title2)
                  Divider()
                  Rectangle()
                    .fill((activity.category?.color ?? .secondary).opacity(0.8))
                    
                }
                .frame(height: 40)
              }
            }
          }
        }
      }
    }
  }
}

struct ReviewViewMainRoutineView_Previews: PreviewProvider {
  static var previews: some View {
    var goal = Goal.getDouble()
    var routine = Routine.getDouble()
    let activity = Activity.getDouble()
    routine.activities = [activity]
    goal.routines = [routine]
    return ReviewViewMainRoutineView(currentGoal: Binding.constant(goal)).padding()
  }
}

extension ActivityCategory {
  var color: Color {
    switch self {
    case .health: return .green
    case .concentrate: return Color(red: 0, green: 1, blue: 1)
    case .normal: return .gray
    case .custom: return .cell
    }
  }
}
