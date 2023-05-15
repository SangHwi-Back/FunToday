//
//  ReviewView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI

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
        Button {
          showPeriod = true
        } label: {
          ZStack {
            RoundedRectangle(cornerRadius: 8)
              .fill(Color.element)
            HStack {
              Text("<").padding(.leading)
              Spacer()
              Text(currentSelectedPeriod.name).padding()
              Spacer()
              Text(">").padding(.trailing)
            }
            .foregroundColor(Color.label)
          }
          .frame(height: 32)
        }
        .padding()
        .popover(
          isPresented: $showPeriod,
          attachmentAnchor: .point(.bottom),
          arrowEdge: .top,
          content: {
            VStack(spacing: 16) {
              ForEach(ReviewViewState.allCases) { state in
                Button(state.name, action: {currentSelectedPeriod = state})
                  .background(Color.element)
                  .disabled(currentSelectedPeriod == state)
              }
            }
            .padding()
          })
        
        ScrollView {
          // MARK: Category Section
          CustomSectionView(title: "카테고리") {
            HStack {
              ForEach(ActivityCategory.allCases) { category in
                VStack {
                  Text(String(describing: category))
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
                  ProgressCircle(status: Binding.constant(ProgressStatus(value: CGFloat.random(in: 0.0...1.0), color: category.color, text: "")))
                }
              }
            }
            .padding(.top)
          }
          .padding(.horizontal)
          
          CustomSectionView(title: "날짜 당 달성률") {
            // TODO: Need View Binding
            HStack(spacing: 4) {
              
              VStack(spacing: 4) {
                ForEach(currentSelectedPeriod.range, id: \.self) { num in
                  Text("\(num+1)")
                }
              }
              .frame(height: 40)
              
              VStack(spacing: 2) {
                ForEach(0...10, id: \.self) { num in
                  Circle().background(Color.element)
                    .frame(width: 1, height: 1)
                }
              }
              .frame(height: 40)
              .padding(.horizontal)
              
              GeometryReader { proxy in
                VStack(alignment: .leading, spacing: 4) {
                  ForEach(currentSelectedPeriod.range, id: \.self) { num in
                    ForEach(getTestRatio.sorted(by: { $0.key.rawValue > $1.key.rawValue }), id: \.key) { activity, ratio in
                      HStack(spacing: 4) {
                        Rectangle()
                          .fill(activity.color.opacity(0.8))
                          .frame(width: proxy.size.width * ratio)
                      }
                    }
                  }
                }
                .frame(height: 40)
              }
            }
            .padding(.top)
          }
          .padding(.horizontal)
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
    case .health:
      return .green
    case .concentrate:
      return .secondary
    case .normal:
      return .gray
    case .custom:
      return .element
    }
  }
}
