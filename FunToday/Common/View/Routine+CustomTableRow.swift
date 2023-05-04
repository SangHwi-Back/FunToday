//
//  Routine+CustomTableRow.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI

extension Routine: RowElement {
  typealias ContentsView = Text
  func getColumns() -> ContentsView {
    Text(self.name + " " + self.description)
  }
}
