//
//  GoalListView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI
import ComposableArchitecture

struct GoalListView: View {
  @Environment(\.presentationMode) var presentationMode
  
  let store: StoreOf<GoalListFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewstore in
      ZStack(alignment: .bottomTrailing) {
        ScrollView {
          LazyVStack {
            ForEachStore(
              store.scope(state: \.goalList, action: GoalListFeature.Action.inputItems(id:action:))
            ) {
              let store = $0
              GoalItem(store: store) {
                NavigationLink {
                  GoalInputView(store: store)
                } label: {
                  GoalItemContents(store: store)
                }
              }
              .navigationBarHidden(true)
            }
          }
        }
        NavigationLink {
          GoalInputView(
            store: store.scope(
              state: \.newGoal,
              action: GoalListFeature.Action.inputNewItem(action:))
          )
        } label: {
          FloatingPlusButton(width: 54)
        }
      }
      .onAppear {
        viewstore.send(.setList)
      }
    }
    .padding(.vertical, 0.1)}
}

struct GoalsView_Previews: PreviewProvider {
  static var previews: some View {
    let initialStore = Store(
      initialState: GoalListFeature.State(goalList: .init()),
      reducer: { GoalListFeature() })
    
    return GoalListView(store: initialStore)
  }
}

struct GoalItemContents: View {
  let store: StoreOf<GoalInputFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewstore in
      VStack(alignment: .leading, spacing: 8) {
        Text(viewstore.goal.name)
          .frame(maxWidth: .infinity, alignment: .leading)
          .font(Font.title)
        
        Text(viewstore.goal.description)
          .lineLimit(3)
          .truncationMode(.tail)
          .font(Font.subheadline)
        
        Label(viewstore.goal.timeFromTo, systemImage: "calendar")
          .frame(maxWidth: .infinity, alignment: .trailing)
          .font(Font.caption)
      }
      .fixedSize(horizontal: false, vertical: true)
      .foregroundColor(Color.label)
    }
  }
}
