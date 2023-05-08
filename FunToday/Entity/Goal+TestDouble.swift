//
//  Goal+TestDouble.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import Foundation

extension Goal: TestDouble {
  static func getDouble(inx: Int = 0) -> Goal {
    .init(
      uniqueID: "1",
      index: inx,
      name: "testName",
      description: "testDescription",
      regDate: Date().description,
      regID: "1",
      routines: [])
  }
}
