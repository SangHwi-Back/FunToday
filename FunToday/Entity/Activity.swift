//
//  Activity.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import Foundation

struct Activity: Identifiable, Entity, Hashable {
  var uniqueID: String
  var id: String {
    uniqueID
  }
  
  var index: Int
  var name: String
  var description: String
  var regDate: String
  var updateDate: String?
  
  var categoryValue: Int
  var category: ActivityCategory? {
    return categoryValue.getType()
  }
  
  /// 활동 시작 시간
  var time_s: String
  var startDate: Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.date(from: time_s) ?? Date()
  }
  /// 활동 종료 시간
  var time_e: String
  var endDate: Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.date(from: time_e) ?? Date()
  }
  
  /// 매일 진행할지 여부
  var isDailyActive: Bool
  /// 주말에는 활성화되지 않을지 여부
  var isWeekendActive: Bool
  /// 활동을 활성 혹은 정지할지 여부
  var isActive: Bool = true
  
  var completionRatio: Int
  var completionCount: Int
  var completionUseSwitch: Bool = false
  
  // MARK: - Not Decoding. Just setter.
  /// yyyy-MM-dd ~ yyyy-MM-dd
  var timeFromTo: String {
    time_s + "~" + time_e
  }
  
  var ratio: Float {
    get {
      Float(completionRatio) / 100
    }
    set(newValue) {
      completionRatio = Int(floor(newValue * 100))
    }
  }
}

enum ActivityCategory: Int, Codable, CaseIterable, Identifiable {
  var id: Self {
    self
  }
  
  case health, concentrate, normal, custom
}

extension Int {
  func getType() -> ActivityCategory? {
    guard (1...4) ~= self else { return nil }
    
    if self == 1 {
      return .health
    } else if self == 2 {
      return .concentrate
    } else if self == 3 {
      return .normal
    } else {
      return .custom
    }
  }
}

@propertyWrapper
struct NoMinusInteger {
  private var value: Int
  
  var wrappedValue: Int {
    get {
      value
    }
    set {
      guard newValue >= 0 else {
        value = 0
        return
      }
      value = newValue
    }
  }
}
