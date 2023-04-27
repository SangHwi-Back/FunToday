//
//  Routine+CustomTableRow.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI

extension Routine: CustomTableRow {
  func getColumns() -> Text {
    Text(self.name + " " + self.description)
  }
}
