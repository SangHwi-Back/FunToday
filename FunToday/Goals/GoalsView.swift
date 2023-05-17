//
//  GoalsView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI
import ComposableArchitecture

struct GoalsView: View {
  
  let store: StoreOf<GoalListFeature>
  
  var body: some View
  { WithViewStore(store, observe: { $0 }) { viewStore in GeometryReader { proxy in NavigationView {
    
    ZStack(alignment: .bottomTrailing) {
      ScrollView {
        LazyVStack {
          ForEach(viewStore.binding(get: { $0.list }, send: .requestGoals)) { goal in
            GoalItem(goal: goal, size: CGSize(width: proxy.size.width - 16, height: 120)) {
              NavigationLink { GoalDetail() } label: {
                GoalItemContents(goal: goal)
              }
            }
            .navigationBarHidden(true)
          }
        }
      }
      .onAppear { viewStore.send(.requestGoals) }
      
      NavigationLink { GoalInsertView() } label: {
        FloatingPlusButton(width: proxy.size.width / 6)
      }
    }
  }
  }}.padding(.vertical, 0.1)}
}

struct GoalsView_Previews: PreviewProvider {
  static var previews: some View {
    let initialStore = Store(
      initialState: GoalListFeature.State(list: []),
      reducer: {
        GoalListFeature()
      }
    )
    return GoalsView(store: initialStore)
  }
}

private struct GoalItemContents: View {
  @Binding var goal: Goal
  var body: some View {
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
