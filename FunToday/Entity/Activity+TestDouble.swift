//
//  Activity+TestDouble.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import Foundation

extension Activity: TestDouble {
  static func getDouble() -> Activity {
    .init(
      uniqueID: "1",
      name: "testName",
      description: "testDescription",
      regDate: Date().description,
      updateDate: nil,
      regID: "testRegID",
      categoryValue: 1,
      time_s: Date(),
      time_e: Date(timeInterval: 1200, since: Date()),
      isDailyRoutine: true,
      noActivateWeekend: false)
  }
}
