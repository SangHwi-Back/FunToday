//
//  Activity+TestDouble.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import Foundation

extension Activity: TestDouble {
  static func getDouble(inx: Int = 0) -> Activity {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let time = formatter.string(from: Date())
    
    return .init(
      index: inx,
      name: "testName",
      description: "testDescription",
      regDate: time,
      categoryValue: 1,
      time_s: time,
      time_e: time)
  }
}
