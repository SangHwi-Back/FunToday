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
      ScrollView(.horizontal) {
        HStack(spacing: 8) {
          ForEach(activities) { activity in
            Button(action: {
              
            }, label: {
              ZStack {
                RoundedRectangle(cornerRadius: 8)
                  .strokeBorder(Color.gray, lineWidth: 2)
                  .foregroundColor(Color.labelReversed)
                Text(activity.name)
                  .padding(.all, 4)
                  .foregroundColor(Color.label)
              }
            })
          }
        }
      }
      .frame(height: 24)
      .padding()
      
      ScrollView(.horizontal) {
        TabView {
          ForEach($activities) { activity in
            ActivityInputView(activity: activity)
              .tag(activity.id)
              .navigationBarTitleDisplayMode(.inline)
              .padding(.horizontal)
          }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(width: proxy.size.width - 32, height: proxy.size.height)
      }
    }
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
    .padding()
    }
  }
}

struct ActivityInputContainer_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ActivityInputContainer(activities: Binding.constant([]))
    }
  }
}
