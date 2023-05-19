//
//  GoalItem.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI
import ComposableArchitecture

struct GoalItem<ContentsView: View>: View {
  
  var store: StoreOf<GoalItemFeature>
  var contentsView: () -> ContentsView
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ZStack
      { CommonRectangle(color: Binding.constant(Color.element))
          .northWestShadow()
        
        ZStack
        { CommonRectangle(color: Binding.constant(Color.cell))
          
          VStack(spacing: 8)
          { contentsView().padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8))
            
            ZStack
            { CommonRectangle(color: Binding.constant(Color.highlight))
              
              VStack(spacing: 8)
              { Image(systemName: "chevron.compact.\(viewStore.isFold ? "down" : "up")")
                  .foregroundColor(Color.element)
                
                if viewStore.isFold == false {
                  HStack
                  {
                    ProgressCircle(status: Binding.constant(ProgressStatus.getDouble()))
                    ProgressCircle(status: Binding.constant(ProgressStatus.getDouble()))
                  }
                  
                  CustomTable([viewStore.goal]) { _ in
                    ["운동", "공부"].map { CustomTableColumn(title: $0, value: \.name) }
                  }
                  .padding()
                }
              }
              .padding(4)
            }
            .frame(minHeight: 18)
            .onTapGesture {
              viewStore.send(.setFold)
            }
          }
        }.padding(8)
      }
      .animation(.easeOut(duration: 0.2), value: viewStore.isFold)
    }
  }
}

struct GoalItem_Previews: PreviewProvider {
  static var previews: some View {
    GoalItem(
      store: Store(
        initialState: GoalItemFeature.State(goal: .getDouble(), id: .init()),
        reducer: GoalItemFeature()
      )) {
        GoalItemContents(goal: Binding.constant(Goal.getDouble()))
      }
  }
}
