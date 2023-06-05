//
//  ReviewViewState.swift
//  FunToday
//
//  Created by 백상휘 on 2023/06/05.
//

import Foundation

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
