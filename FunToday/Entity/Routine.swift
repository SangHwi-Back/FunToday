//
//  Routine.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import Foundation

struct Routine: Identifiable, Entity {
  var uniqueID: String
  
  var id: String {
    uniqueID
  }
  
  var index: Int
  var name: String
  var description: String
  var regDate: String
  var updateDate: String?
  
  var activities: [Activity]
  
  var timeFromTo: String {
    updateDate ?? "none"
  }
}
