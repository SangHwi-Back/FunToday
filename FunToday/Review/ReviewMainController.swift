//
//  ReviewMainController.swift
//  FunToday
//
//  Created by 백상휘 on 2023/06/05.
//

import SwiftUI

struct ReviewMainController: View {
  
  @Binding var goals: [Goal]
  @Binding var currentGoal: Goal?
  
  var body: some View {
    HStack(spacing: 8) {
      Button(action: {}) {
        HStack {
          Text("<")
          Spacer(minLength: 8)
          Text(currentGoal?.name ?? "none")
          Spacer(minLength: 8)
          Text(">")
        }
        .padding()
      }
      .background(Color.element)
      .cornerRadius(8)
      .contextMenu(ContextMenu(menuItems: {
        VStack(spacing: 16) {
          ForEach(goals) { goal in
            Button(goal.name, action: { currentGoal = goal })
              .disabled(goal == currentGoal)
          }
        }
      }))
    }
    .foregroundColor(Color.label)
    .frame(height: 48)
  }
}

struct ReviewMainHeader_Previews: PreviewProvider {
  static var previews: some View {
    let goals = [Goal.getDouble()]
    return VStack {
      Spacer()
      ReviewMainController(
        goals: Binding.constant(goals),
        currentGoal: Binding.constant(goals.first))
      .padding()
    }
  }
}
