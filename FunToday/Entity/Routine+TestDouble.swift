//
//  Routine+TestDouble.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import Foundation

extension Routine: TestDouble {
  static func getDouble() -> Routine {
    .init(
      uniqueID: "1",
      name: "testRoutine",
      description: "testDescription",
      regDate: Date().description,
      updateDate: nil,
      regID: "1",
      activities: [])
  }
}
