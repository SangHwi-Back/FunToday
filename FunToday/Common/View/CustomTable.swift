//
//  CustomTable.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/09.
//

import SwiftUI

struct CustomTable<T>: View {
  
  var data: [T]
  var columnGuide: [CustomTableColumn<T>]
  
  init(
    _ data: [T],
    _ columnHandler: @escaping (T)->[CustomTableColumn<T>])
  {
    self.data = data
    self.columnGuide = data.map(columnHandler).first ?? []
  }
  
  var body: some View {
    HStack(spacing: 0) {
      ForEach(columnGuide, id: \.self) { columnInfo in
        
        VStack {
          ForEach(0...data.count, id: \.self) { rowNumber in
            ZStack {
              let isTitle = rowNumber == 0
              let title = isTitle ?
                columnInfo.title :
                data[rowNumber-1][keyPath: columnInfo.value]
              
              Rectangle()
                .fill(isTitle ? Color.tableTitle : Color.labelReversed)
              
              Text(title)
                .frame(alignment: .leading)
                .padding(4)
                .foregroundColor(Color.label)
                .minimumScaleFactor(0.2)
                .lineLimit(isTitle ? 1 : 8)
            }
          }
        }
        .aspectRatio(contentMode: .fit)
      }
    }
    .border(Color.border)
    .aspectRatio(contentMode: .fit)
  }
  
  
  private func getGrid(columnCount: Int) -> [GridItem] {
    return Array(
      repeating: GridItem(.flexible()),
      count: columnCount)
  }
}

struct CustomTableColumn<T>: Hashable {
  var title: String
  var value: KeyPath<T, String>
}

protocol RowElement where ContentsView: View {
  associatedtype ContentsView
  func getColumns() -> ContentsView
}

struct CustomTable_Previews: PreviewProvider {
  static var previews: some View {
    let data = Array(repeating: Activity.getDouble(), count: 4)
    CustomTable(data) { routine in
      [
        CustomTableColumn(title: "이름", value: \.name),
        CustomTableColumn(title: "수행날짜", value: \.timeFromTo),
        CustomTableColumn(title: "설명", value: \.description)
      ]
    }
  }
}
