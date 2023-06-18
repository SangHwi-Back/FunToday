//
//  Routine+TestDouble.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import Foundation

extension Routine: TestDouble {
  static func getDouble(inx: Int = 0) -> Routine {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let time = formatter.string(from: Date())
    
    return .init(
      uniqueID: UUID().uuidString,
      index: inx,
      name: "testRoutine",
      description: "testDescription",
      regDate: time)
  }
}
