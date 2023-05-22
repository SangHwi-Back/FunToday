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
  { WithViewStore(store, observe: { $0 }) { viewStore in NavigationView {
    ZStack(alignment: .bottomTrailing) {
      ScrollView {
        LazyVStack {
          ForEachStore(
            store.scope(state: \.goalList, action: GoalListFeature.Action.goalItem(id:action:))
          ) {
            GoalItem(store: $0) {
              NavigationLink { GoalDetail() } label: {
                GoalItemContents(goal: Binding.constant(Goal.getDouble()))
              }
            }
            .navigationBarHidden(true)
          }
        }
      }
      NavigationLink {
        GoalInputView(
          store: Store(
            initialState: GoalInputFeature.State(
              goal: .getDouble(),
              routines: .init()
            ),
            reducer: {
              GoalInputFeature()
            }
          )
        )
      } label: {
        FloatingPlusButton(width: 54)
      }
    }
  }}.padding(.vertical, 0.1)}
}

struct GoalsView_Previews: PreviewProvider {
  static var previews: some View {
    let initialStore = Store(
      initialState: GoalListFeature.State(goalList: .init()),
      reducer: { GoalListFeature() })
    
    return GoalsView(store: initialStore)
  }
}

struct GoalItemContents: View {
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
