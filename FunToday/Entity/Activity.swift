//
//  Activity.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import Foundation

struct Activity: Entity {
  var uniqueID: String
  var name: String
  var description: String
  var regDate: String
  var updateDate: String?
  var regID: String
  
  var categoryValue: Int
  var category: ActivityCategory? {
    return categoryValue.getType()
  }
  
  /// 활동 시작 시간
  var time_s: Date
  /// 활동 종료 시간
  var time_e: Date
  
  /// 매일 진행할지 여부
  var isDailyRoutine: Bool
  /// 주말에는 활성화되지 않을지 여부
  var noActivateWeekend: Bool
  
  var isActive: Bool = true
}

enum ActivityCategory: Int, Codable {
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
