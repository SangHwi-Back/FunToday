//
//  ActivityInputContainer.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/12.
//

import SwiftUI

struct ActivityInputContainer: View {
  @Binding var activities: [Activity]
  
  var body: some View {
    GeometryReader { proxy in VStack(spacing: 12) {
      ActivityButtonScrollView(activities: $activities)
        .frame(height: 24)
        .padding(.vertical)
      ActivityInputScrollView(activities: $activities, size: proxy.size)
    }}
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: {
          activities.append(Activity.getDouble(inx: activities.count))
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

struct ActivityButtonScrollView: View {
  @Binding var activities: [Activity]
  
  var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 18) {
        ForEach($activities) { activity in
          ActivityButton(activity: activity, minusButtonHandler: {
//            let aa = $0
            
            activities.removeAll(where: { $0 == activity.wrappedValue })
          })
        }
      }
    }
  }
  
  struct ActivityButton: View {
    @Binding var activity: Activity
    
    var actionHandler: (() -> Void)?
    var minusButtonHandler: (() -> Void)?
    
    var body: some View {
      Button {
        actionHandler?()
      } label: {
        ZStack {
          RoundedRectangle(cornerRadius: 8)
            .strokeBorder(Color.gray, lineWidth: 2)
          Text(activity.name)
            .foregroundColor(Color.label)
            .padding()
        }
        // TODO: iOS 15.0 compatible issue
//        .overlay {
//          FloatingMinusButton(width: 24) {
//            minusButtonHandler?()
//          }
//          .offset(x: 20, y: -20)
//        }
      }
    }
  }
}

struct ActivityInputScrollView: View {
  @Binding var activities: [Activity]
  var size: CGSize
  
  var body: some View {
    ScrollView(.horizontal) {
      TabView {
        ForEach($activities) { activity in
          ActivityInputView(activity: activity).tag(activity.id)
        }
      }
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: activities.isEmpty ? .never : .always))
      .navigationBarTitleDisplayMode(.inline)
      .frame(width: size.width, height: size.height - 16)
    }
  }
}

struct ActivityInputContainer_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ActivityInputContainer(activities: Binding.constant([Activity.getDouble(inx: 0), Activity.getDouble(inx: 1)]))
    }
  }
}

extension Identifiable where ID == String {
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }
  
  var id: String {
    self.id
  }
}
