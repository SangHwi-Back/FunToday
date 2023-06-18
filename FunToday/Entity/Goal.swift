//
//  Goal.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import Foundation

struct Goal: Hashable, Identifiable, Entity {
  enum CodingKeys: CodingKey {
    case uniqueID, index, name, description, regDate, updateDate, routines, isFold, time_s, time_e
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
  var routines: [Routine]
  var isFold: Bool = true
  
  var timeFromTo: String {
    regDate + " ~ " + (updateDate ?? regDate)
  }
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
  
  init(
    uniqueID: String = UUID().uuidString,
    index: Int,
    name: String,
    description: String,
    regDate: String,
    routines: [Routine] = [],
    isFold: Bool = true,
    time_s: String,
    time_e: String
  ) {
    self.uniqueID = uniqueID
    self.index = index
    self.name = name
    self.description = description
    self.regDate = regDate
    self.updateDate = regDate
    self.routines = routines
    self.isFold = isFold
    self.time_s = time_s
    self.time_e = time_e
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.uniqueID, forKey: .uniqueID)
    try container.encode(self.index, forKey: .index)
    try container.encode(self.name, forKey: .name)
    try container.encode(self.description, forKey: .description)
    try container.encode(self.regDate, forKey: .regDate)
    try container.encodeIfPresent(self.updateDate, forKey: .updateDate)
    try container.encode(self.routines, forKey: .routines)
    try container.encode(self.isFold, forKey: .isFold)
    try container.encode(self.time_s, forKey: .time_s)
    try container.encode(self.time_e, forKey: .time_e)
  }
}
