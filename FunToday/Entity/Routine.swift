//
//  Routine.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import Foundation

struct Routine: Identifiable, Entity {
  var uniqueID: String
  var index: Int
  var name: String
  var description: String
  var regDate: String
  var updateDate: String?
  var regID: String
  
  var activities: [Activity]
  
  typealias ID = String
  var id: ID {
    uniqueID
  }
}
