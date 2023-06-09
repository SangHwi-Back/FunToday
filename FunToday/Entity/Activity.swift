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
  var category: Category {
    categoryValue.getType()
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
  var activeWeekDays: Set<Weekday> = [.mon, .tue, .wed, .thu, .fri]
  /// 주말에는 활성화되지 않을지 여부
  var isWeekendActive: Bool
  var activeWeekends: Set<Weekend> = []
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
  
  func isActive(weekday: Weekday) -> Bool {
    activeWeekDays.contains(weekday)
  }
  
  func isActive(weekend: Weekend) -> Bool {
    activeWeekends.contains(weekend)
  }
  
  enum Weekday: Int, CaseIterable, Identifiable {
    var id: Self {
      self
    }
    
    case mon = 0
    case tue = 1
    case wed = 2
    case thu = 3
    case fri = 4
    
    var name: String {
      switch self {
      case .mon: return "월요일"
      case .tue: return "화요일"
      case .wed: return "수요일"
      case .thu: return "목요일"
      case .fri: return "금요일"
      }
    }
    var shortName: String {
      String(self.name.first ?? Character(""))
    }
  }
  
  enum Weekend: Int, CaseIterable, Identifiable {
    var id: Self {
      self
    }
    
    case sat = 5
    case sun = 6
    
    var name: String {
      switch self {
      case .sat: return "토요일"
      case .sun: return "일요일"
      }
    }
    var shortName: String {
      String(self.name.first ?? Character(""))
    }
  }
  
  enum Category: Int, Codable, CaseIterable, Identifiable {
    var id: Self {
      self
    }
    
    case health, concentrate, normal, custom
    
    var name: String {
      switch self {
      case .health:
        return "건강"
      case .concentrate:
        return "집중"
      case .normal:
        return "일반"
      case .custom:
        return "그 외"
      }
    }
  }
  
  enum CodingKeys: CodingKey {
    case uniqueID, index, name, description, regDate, updateDate, categoryValue, time_s, time_e, isDailyActive, activeWeekDays, isWeekendActive, activeWeekends, isActive, completionRatio, completionCount, completionUseSwitch
  }
  
  init(uniqueID: String,
       index: Int,
       name: String,
       description: String,
       regDate: String,
       updateDate: String? = nil,
       categoryValue: Int,
       time_s: String,
       time_e: String,
       isDailyActive: Bool,
       isWeekendActive: Bool,
       isActive: Bool,
       completionRatio: Int,
       completionCount: Int,
       completionUseSwitch: Bool) {
    
    self.uniqueID = uniqueID
    self.index = index
    self.name = name
    self.description = description
    self.regDate = regDate
    self.updateDate = updateDate
    self.categoryValue = categoryValue
    self.time_s = time_s
    self.time_e = time_e
    self.isDailyActive = isDailyActive
    self.isWeekendActive = isWeekendActive
    self.isActive = isActive
    self.completionRatio = completionRatio
    self.completionCount = completionCount
    self.completionUseSwitch = completionUseSwitch
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    uniqueID = try container.decode(String.self, forKey: .uniqueID)
    index = try container.decode(Int.self, forKey: .index)
    name = try container.decode(String.self, forKey: .name)
    description = try container.decode(String.self, forKey: .description)
    regDate = try container.decode(String.self, forKey: .regDate)
    updateDate = try container.decodeIfPresent(String.self, forKey: .updateDate)
    categoryValue = try container.decode(Int.self, forKey: .categoryValue)
    time_s = try container.decode(String.self, forKey: .time_s)
    time_e = try container.decode(String.self, forKey: .time_e)
    isDailyActive = try container.decode(Bool.self, forKey: .isDailyActive)
    let _activeWeekDays = try container.decode(Array<Int>.self, forKey: .activeWeekDays)
    activeWeekDays = Set(_activeWeekDays.sorted().compactMap({$0.toWeekDay()}))
    isWeekendActive = try container.decode(Bool.self, forKey: .isWeekendActive)
    let _activeWeekends = try container.decode(Array<Int>.self, forKey: .activeWeekends)
    activeWeekends = Set(_activeWeekends.sorted().compactMap({$0.toWeekend()}))
    isActive = try container.decode(Bool.self, forKey: .isActive)
    completionRatio = try container.decode(Int.self, forKey: .completionRatio)
    completionCount = try container.decode(Int.self, forKey: .completionCount)
    completionUseSwitch = try container.decode(Bool.self, forKey: .completionUseSwitch)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(uniqueID, forKey: .uniqueID)
    try container.encode(index, forKey: .index)
    try container.encode(name, forKey: .name)
    try container.encode(description, forKey: .description)
    try container.encode(regDate, forKey: .regDate)
    try container.encode(updateDate, forKey: .updateDate)
    try container.encode(categoryValue, forKey: .categoryValue)
    try container.encode(time_s, forKey: .time_s)
    try container.encode(time_e, forKey: .time_e)
    try container.encode(isDailyActive, forKey: .isDailyActive)
    try container.encode(Array(activeWeekDays.map({$0.rawValue}).sorted()), forKey: .activeWeekDays)
    try container.encode(isWeekendActive, forKey: .isWeekendActive)
    try container.encode(Array(activeWeekends.map({$0.rawValue}).sorted()), forKey: .activeWeekends)
    try container.encode(isActive, forKey: .isActive)
    try container.encode(completionRatio, forKey: .completionRatio)
    try container.encode(completionCount, forKey: .completionCount)
    try container.encode(completionUseSwitch, forKey: .completionUseSwitch)
  }
}

extension Int {
  func getType() -> Activity.Category {
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
  
  func toWeekDay() -> Activity.Weekday? {
    if self == 0 {
      return .mon
    } else if self == 1 {
      return .tue
    } else if self == 2 {
      return .wed
    } else if self == 3 {
      return .thu
    } else if self == 4 {
      return .fri
    } else {
      return nil
    }
  }
  
  func toWeekend() -> Activity.Weekend? {
    if self == 5 {
      return .sat
    } else if self == 6 {
      return .sun
    } else {
      return nil
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
