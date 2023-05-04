//
//  ReviewView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI

struct ReviewView: View {
  var body: some View {
    GeometryReader { proxy in
      VStack(alignment: .center, spacing: 8) {
        HStack(alignment: .center, spacing: 24) {
          ProgressCircle<Button<Text>>(
            value: Binding.constant(CGFloat(0.9)),
            mainColor: Binding.constant(Color.red),
            contentsHandler: Binding.constant({
              Button {
                print("testing")
              } label: {
                Text("90%")
              }
            }))
            .buttonStyle(CommonPushButtonStyle())
          
          ProgressCircle<Text>(
            value: Binding.constant(CGFloat(0.5)),
            mainColor: Binding.constant(Color.red),
            contentsHandler: Binding.constant({ Text("50%") }))
        }
        .padding(.horizontal)
        
        CustomTable(
          columnTitles: ["이름", "활동"],
          rowData: [
            Routine.getDouble(),
            Routine.getDouble(),
            Routine.getDouble(),
            Routine.getDouble(),
          ])
      }
    }
  }
}

struct ReviewView_Previews: PreviewProvider {
  static var previews: some View {
    ReviewView()
  }
}

struct CustomTable<Element>: View where Element: CustomTableRow {
  
  var columnTitles: [String]
  private var column: Int {
    columnTitles.count
  }
  var rowData: [Element]
  private var row: Int {
    rowData.count
  }
  
  var body: some View {
    VStack { ForEach(0...row, id: \.self) { row in
      HStack { ForEach(0..<column, id: \.self) { column in
        if row == 0 {
          Text(columnTitles[column])
            .padding(8)
          Spacer()
        } else {
          rowData[row-1].getColumns()
            .padding(.vertical, 8)
        }
      }}
    }}
    .padding(10)
  }
}

protocol CustomTableRow {
  func getColumns() -> Text
}
