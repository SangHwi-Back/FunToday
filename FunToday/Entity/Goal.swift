//
//  Goal.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import Foundation

struct Goal: Entity {
  var uniqueID: String
  
  var name: String
  
  var description: String
  
  var regDate: String
  
  var updateDate: String?
  
  var regID: String
  
  var routines: [Routine]
  var activeRoutine: Routine?
}
