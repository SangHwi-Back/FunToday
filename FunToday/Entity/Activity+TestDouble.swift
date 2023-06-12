//
//  Activity+TestDouble.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import Foundation

extension Activity: TestDouble {
  static func getDouble(inx: Int = 0) -> Activity {
    .init(
      uniqueID: UUID().uuidString,
      index: inx,
      name: "testName",
      description: "testDescription",
      regDate: Date().description,
      updateDate: nil,
      categoryValue: 1,
      time_s: "2023-05-10",
      time_e: "2023-05-13",
      isDailyActive: true,
      isWeekendActive: false,
      isActive: true,
      completionCount: 0,
      completionRatio: 0)
  }
}
