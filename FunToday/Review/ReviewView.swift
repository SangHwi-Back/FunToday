//
//  ReviewView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI

private struct ReviewViewHeaderElement<ContentsView: View>: View {
  private var contents: () -> ContentsView
  
  init(_ contents: @escaping () -> ContentsView) {
    self.contents = contents
  }
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 8)
        .fill(Color.element)
      contents()
    }
  }
}

struct ReviewView: View {
  
  enum ReviewViewState: Identifiable, CaseIterable {
    var id: Self {
      return self
    }
    
    case today, week, month, custom
    
    // TODO: Localization
    var name: String {
      switch self {
      case .today: return "오늘"
      case .week: return "이번 주"
      case .month: return "이번 달"
      case .custom: return ""
      }
    }
    
    var range: Range<Int> {
      switch self {
      case .today: return 0..<1
      case .week: return 0..<7
      case .month: return 0..<30
      case .custom: return 0..<100
      }
    }
  }
  
  @EnvironmentObject var db: DependencyFirebaseDB
  
  // MARK: [Start] Data for boiler-plate
  var goals: [Goal] = {
    var result = [Goal]()
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    for i in 0..<Int.random(in: 2...5) {
      var goal = Goal.getDouble(inx: i)
      
      for j in 0..<Int.random(in: 1...3) {
        var routine = Routine.getDouble(inx: j)
        
        for k in 0..<Int.random(in: 1...10) {
          var activity = Activity.getDouble(inx: k)
          let randomValue = Int.random(in: 0...100)
          
          activity.time_s = "2023-05-\(Int.random(in: 0...31))"
          activity.completionRatio = randomValue
          activity.completionUseSwitch = randomValue.isMultiple(of: 2)
          
          routine.activities.append(activity)
        }
        
        goal.routines.append(routine)
      }
      
      goal.activeRoutine = goal.routines.shuffled().first
      
      result.append(goal)
    }
    
    return result
  }()
  
  init() {
    self.currentGoal = goals.first!
    
    for i in 0 ..< goals.count {
      if goals[i].activeRoutine != nil {
        self.currentGoal = goals[i]
        break
      }
    }
  }
  // MARK: [ End ] Data for boiler-plate
  
  // MARK: States of current data
  @State private var currentGoal: Goal
  
  // MARK: States of view
  @State private var showPeriod: Bool = false
  @State private var currentSelectedPeriod: ReviewViewState = .today
  
  // MARK: For Test
  var getTestRatio: [ActivityCategory: CGFloat] {
    [
      .health: CGFloat.random(in: 0...1.0),
      .concentrate: CGFloat.random(in: 0...1.0),
      .normal: CGFloat.random(in: 0...1.0),
      .custom: CGFloat.random(in: 0...1.0),
    ]
  }
  
  var body: some View {
    GeometryReader { proxy in
      VStack(spacing: 8) {
        
        // MARK: Header Button
        HStack(spacing: 8) {
          ReviewViewHeaderElement {
            Text("\(currentGoal.name)")
          }
          .aspectRatio(1, contentMode: ContentMode.fit)
          .contextMenu(ContextMenu(menuItems: {
            VStack(spacing: 8) {
              ForEach(goals) { goal in
                Button(goal.name, action: { currentGoal = goal })
                  .disabled(goal == currentGoal)
              }
            }
          }))
          
          ReviewViewHeaderElement {
            HStack {
              Text("<")
              Spacer(minLength: 8)
              Text(currentSelectedPeriod.name)
              Spacer(minLength: 8)
              Text(">")
            }
            .padding(.horizontal)
          }
          .onTapGesture(perform: { showPeriod = true })
          .popover(
            isPresented: $showPeriod,
            attachmentAnchor: .point(.bottom),
            arrowEdge: .top,
            content: {
              VStack(spacing: 16) {
                ForEach(ReviewViewState.allCases) { state in
                  Button(state.name, action: {
                    currentSelectedPeriod = state
                    showPeriod = false
                  })
                  .background(Color.element)
                  .disabled(currentSelectedPeriod == state)
                }
              }
              .padding()
            }
          )
        }
        .foregroundColor(Color.label)
        .frame(height: 48)
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
        
        if let routine = currentGoal.activeRoutine {
          ScrollView {
            // MARK: Category Section
            CustomSectionView(title: "카테고리") {
              HStack {
                ForEach(routine.activities.map({ $0.category }).compactMap({$0})) { category in
                  VStack {
                    Text(String(describing: category))
                      .minimumScaleFactor(0.2)
                      .lineLimit(1)
                    ProgressCircle(status: Binding.constant(ProgressStatus(value: CGFloat.random(in: 0.0...1.0), color: category.color, text: "")))
                  }
                }
              }
              .padding(EdgeInsets(top: 8, leading: -8, bottom: 0, trailing: -8))
            }
            .padding(.horizontal)
            
            // TODO: Need View Binding
            CustomSectionView(title: "날짜 당 달성률") {
              HStack(spacing: 4) {
                
                VStack(spacing: 12) {
                  ForEach(routine.activities, id: \.self) { activity in
                    Text(activity.time_s.split(separator: "-").last ?? "0")
                      .frame(height: 40)
                  }
                }
                
                VStack(spacing: 12) {
                  ForEach(routine.activities, id: \.self) { _ in
                    DottedLine()
                  }
                }
                
                GeometryReader { proxy in
                  VStack(alignment: .leading, spacing: 12) {
                    ForEach(routine.activities, id: \.self) { activity in
                      Rectangle()
                        .fill((activity.category?.color ?? .secondary).opacity(0.8))
                        .frame(width: proxy.size.width * CGFloat(activity.ratio), height: 40)
                    }
                  }
                }
              }
              .padding(.top)
            }
            .padding(.horizontal)
            
            CustomSectionView(title: "요약") {
              Text("")
            }
            .padding(.horizontal)
          }
        }
      }
    }
  }
}

struct ReviewView_Previews: PreviewProvider {
  static var previews: some View {
    ReviewView()
  }
}

extension ActivityCategory {
  var color: Color {
    switch self {
    case .health: return .green
    case .concentrate: return .cyan
    case .normal: return .gray
    case .custom: return .cell
    }
  }
}
