//
//  Goal.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import Foundation

struct Goal: Identifiable, Entity, Equatable {
  static func == (lhs: Goal, rhs: Goal) -> Bool {
    lhs.id == rhs.id
  }
  
  var uniqueID: String
  
  var id: String {
    uniqueID
  }
  
  var index: Int
  
  var name: String
  
  var description: String
  
  var regDate: String
  
  var updateDate: String?
  
  var timeFromTo: String {
    regDate + " ~ " + (updateDate ?? regDate)
  }
  
  var routines: [Routine]
  var activeRoutine: Routine?
  
  var isFold: Bool = true
}
