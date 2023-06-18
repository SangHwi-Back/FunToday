//
//  Routine.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import Foundation

struct Routine: Identifiable, Entity, Hashable {
  enum CodingKeys: CodingKey {
    case uniqueID
    case index
    case name
    case description
    case regDate
    case updateDate
    case time_s
    case time_e
    case activities
  }
  
  let dateFormatter: DateFormatter = {
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd HH:mm"
    return format
  }()
  
  var uniqueID: String
  var id: String {
    uniqueID
  }
  
  var index: Int
  var name: String
  var description: String
  var regDate: String
  var updateDate: String?
  
  /// 활동 시작 시간
  var time_s: String
  var startDate: Date {
    get {
      dateFormatter.date(from: time_s) ?? Date()
    }
    set {
      time_s = dateFormatter.string(from: newValue)
    }
  }
  /// 활동 종료 시간
  var time_e: String
  var endDate: Date {
    get {
      dateFormatter.date(from: time_e) ?? Date()
    }
    set {
      time_e = dateFormatter.string(from: newValue)
    }
  }
  
  var activities: [Activity]
  
  var timeFromTo: String {
    updateDate ?? "none"
  }
  
  init(uniqueID: String,
       index: Int,
       name: String,
       description: String,
       regDate: String,
       activities: [Activity] = []) {
    self.uniqueID = uniqueID
    self.index = index
    self.name = name
    self.description = description
    self.regDate = regDate
    self.updateDate = regDate
    self.time_s = regDate
    self.time_e = regDate
    self.activities = activities
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    uniqueID = try container.decode(String.self, forKey: .uniqueID)
    index = try container.decode(Int.self, forKey: .index)
    name = try container.decode(String.self, forKey: .name)
    description = try container.decode(String.self, forKey: .description)
    regDate = try container.decode(String.self, forKey: .regDate)
    updateDate = try container.decodeIfPresent(String.self, forKey: .updateDate)
    time_s = try container.decode(String.self, forKey: .time_s)
    time_e = try container.decode(String.self, forKey: .time_e)
    activities = try container.decode([Activity].self, forKey: .activities)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(self.uniqueID, forKey: .uniqueID)
    try container.encode(self.index, forKey: .index)
    try container.encode(self.name, forKey: .name)
    try container.encode(self.description, forKey: .description)
    try container.encode(self.regDate, forKey: .regDate)
    try container.encodeIfPresent(self.updateDate, forKey: .updateDate)
    try container.encode(self.time_s, forKey: .time_s)
    try container.encode(self.time_e, forKey: .time_e)
    try container.encode(self.activities, forKey: .activities)
  }
}
