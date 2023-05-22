//
//  ActivityInputContainer.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/12.
//

import SwiftUI
import ComposableArchitecture

struct ActivityInputContainer: View {
  let store: StoreOf<ActivityContainerFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewstore in GeometryReader { proxy in VStack(spacing: 12) {
      ActivityButtonScrollView(store: store)
        .frame(height: 24)
        .padding(.vertical)
      ActivityInputScrollView(store: store, size: proxy.size)
    }}
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: {
          viewstore.send(.addActivity)
        }, label: {
          Image(systemName: "plus")
            .resizable()
            .clipShape(Circle())
        })
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle("활동 추가")
    .padding()
    }
  }
}

struct ActivityContainerFeature: ReducerProtocol {
  struct State: Equatable, Identifiable {
    static func == (lhs: ActivityContainerFeature.State, rhs: ActivityContainerFeature.State) -> Bool {
      lhs.id == rhs.id
    }
    
    var id: UUID = .init()
    var activities: IdentifiedArrayOf<ActivityInputFeature.State>
  }
  
  enum Action {
    case addActivity
    case removeActivity
    case activityElement(id: ActivityInputFeature.State.ID, action: ActivityInputFeature.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .addActivity:
        state.activities.append(.init(activity: Activity.getDouble()))
        return .none
      case .removeActivity:
        return .none
      case .activityElement(id: let id, action: .removeActivity):
        state.activities.remove(id: id)
        return .none
      case .activityElement:
        return .none
      }
    }.forEach(\.activities, action: /Action.activityElement(id:action:)) {
      ActivityInputFeature()
    }
  }
  
  // MARK: - Inner State
  enum ActivityHeaderButtonType {
    case basic, minus
  }
}

struct ActivityButtonScrollView: View {
  let store: StoreOf<ActivityContainerFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewstore in
      ScrollView(.horizontal) {
        HStack(spacing: 18) {
          ForEachStore(
            store.scope(state: \.activities, action: ActivityContainerFeature.Action.activityElement(id:action:))
          ) {
            ActivityButton(store: $0)
          }
        }
      }
    }
  }
  
  struct ActivityButton: View {
    let store: StoreOf<ActivityInputFeature>
    
    var body: some View {
      WithViewStore(store, observe: { $0 }) { viewstore in
        Button {
          viewstore.send(.buttonTapped(id: viewstore.id, buttontype: .basic))
        } label: {
          ZStack {
            RoundedRectangle(cornerRadius: 8)
              .strokeBorder(Color.gray, lineWidth: 2)
            Text(viewstore.activity.name)
              .foregroundColor(Color.label)
              .padding()
          }
          .overlay({
            GeometryReader { proxy in
              FloatingMinusButton(width: 24) {
                viewstore.send(.buttonTapped(id: viewstore.id, buttontype: .minus))
              }
              .offset(x: -24, y: -24)
            }
          }())
        }
      }
    }
  }
}

struct ActivityInputScrollView: View {
  let store: StoreOf<ActivityContainerFeature>
  
  var size: CGSize
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewstore in
      ScrollView(.horizontal) {
        TabView {
          ForEachStore(
            store.scope(state: \.activities, action: ActivityContainerFeature.Action.activityElement(id:action:))
          ) {
            ActivityInputView(store: $0)
          }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: viewstore.activities.isEmpty ? .never : .always))
        .navigationBarTitleDisplayMode(.inline)
        .frame(width: size.width, height: size.height - 16)
      }
    }
  }
}

//struct ActivityInputContainer_Previews: PreviewProvider {
//  static var previews: some View {
//    NavigationView {
//      ActivityInputContainer(activities: Binding.constant([Activity.getDouble(inx: 0), Activity.getDouble(inx: 1)]))
//    }
//  }
//}

extension Identifiable where ID == String {
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }
  
  var id: String {
    self.id
  }
}
