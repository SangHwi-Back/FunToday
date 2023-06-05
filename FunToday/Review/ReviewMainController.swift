//
//  ReviewMainController.swift
//  FunToday
//
//  Created by 백상휘 on 2023/06/05.
//

import SwiftUI

struct ReviewMainController: View {
  
  @Binding var goals: [Goal]
  var currentGoal: Goal?
  
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
            Button {
              guard let inx = goals.firstIndex(of: goal) else { return }
              let removed = goals.remove(at: inx)
              goals.insert(removed, at: 0)
            } label: {
              Text(goal.name)
            }
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
        currentGoal: goals.first)
      .padding()
    }
  }
}
