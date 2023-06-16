//
//  ReviewViewMainRoutineView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/06/05.
//

import SwiftUI

struct ReviewViewMainRoutineView: View {
  @Binding var goals: [Goal]
  var currentGoal: Goal?
  
  var body: some View {
    ScrollView {
      VStack(spacing: 8) {
        if let routines = currentGoal?.routines {
          ForEach(routines) { routine in
            Text(routine.name)
              .font(Font.title)
              .frame(maxWidth: .infinity, alignment: .leading)
            if routine.activities.isEmpty {
              CustomSectionView {
                VStack {
                  Text("활동 내역이 없습니다.")
                    .font(Font.title)
                  Text("목표 내역에서 활동 내역을 추가할 수 있습니다.")
                    .font(Font.subheadline)
                }
              }
            }
            else {
              HorizontalProgressScrollView(activities: routine.activities)
                .frame(height: 120)
              
              VerticalActivityStackView(activities: routine.activities)
            }
          }
        }
      }
    }
  }
}

private struct HorizontalProgressScrollView: View {
  
  let activities: [Activity]
  
  var body: some View {
    CustomSectionView {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          ForEach(activities, id: \.id) { activity in
            VStack {
              ProgressCircle(ProgressStatus(value: CGFloat(activity.ratioCompletion / 100), color: activity.category.color))
              Text(String(describing: activity.category.name))
                .minimumScaleFactor(0.2)
                .font(.caption)
            }
          }
        }
      }
    }
  }
}

private struct VerticalActivityStackView: View {
  let activities: [Activity]
  
  var body: some View {
    CustomSectionView {
      ForEach(activities) { activity in
        VStack(spacing: 8) {
          Text(activity.name)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
          Text(activity.description)
            .font(.subheadline)
            .frame(maxWidth: .infinity, alignment: .leading)
          Text(activity.time_s + " ~ " + activity.time_e)
            .font(.subheadline)
          OneWeekHStackView(activity: activity)
            .cornerRadius(8)
          Divider()
          
          if let completionAs = activity.completionAs.toCompletionType() {
            switch completionAs {
            case .count:
              countStack(activity)
            case .slider:
              titledBarChart(activity)
                .frame(height: 40)
            }
          }
          
          Divider()
            .padding(.bottom)
        }
      }
    }
  }
  
  private func countStack(_ activity: Activity) -> some View {
    HStack {
      Text("\(activity.countCompletion)")
        .font(.headline)
        .frame(alignment: .centerLastTextBaseline)
      Text(" / \(activity.completionCount)")
        .font(.title)
    }
  }
  
  private func titledBarChart(_ activity: Activity) -> some View {
    GeometryReader { proxy in
      ZStack(alignment: .leading) {
        Rectangle()
          .fill(Color.shadow.opacity(0.3))
        Rectangle()
          .fill((activity.category.color).opacity(0.8))
          .frame(width: proxy.size.width * CGFloat(activity.ratioCompletion / 100))
      }
    }
  }
}

private struct OneWeekHStackView: View {
  let activity: Activity
  
  var body: some View {
    HStack {
      ForEach([0,1,2,3,4], id: \.self) { num in
        getButton(Activity.Weekday.allCases[num].shortName, isActive: activity.isActiveWeekDay(num: num))
      }
      ForEach([0,1], id: \.self) { num in
        getButton(Activity.Weekend.allCases[num].shortName, isActive: activity.isActiveWeekend(num: num+5))
      }
    }
  }
  
  private func getButton(_ txt: String, isActive: Bool) -> some View {
    return Text(txt)
      .minimumScaleFactor(0.2)
      .padding(12)
      .scaledToFill()
      .foregroundColor(isActive ? .white : .label)
      .background(isActive ? activity.category.color : Color.element)
  }
}

struct ReviewViewMainRoutineView_Previews: PreviewProvider {
  static var previews: some View {
    var goal = Goal.getDouble()
    var routine = Routine.getDouble()
    let activity = Activity.getDouble()
    routine.activities = [activity]
    goal.routines = [routine]
    return ReviewViewMainRoutineView(goals: Binding.constant([goal])).padding()
  }
}

private extension Activity.Category {
  var color: Color {
    switch self {
    case .health: return .green
    case .concentrate: return Color(red: 0, green: 1, blue: 1)
    case .normal: return .gray
    case .custom: return .cell
    }
  }
}

private extension Activity {
  func isActiveWeekDay(num: Int) -> Bool {
    activeWeekDays.map({$0.rawValue}).sorted().contains(num)
  }
  
  func isActiveWeekend(num: Int) -> Bool {
    activeWeekends.map({$0.rawValue}).sorted().contains(num)
  }
}
