//
//  CustomTable.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/09.
//

import SwiftUI

struct CustomTable<T>: View where T: Identifiable {
  
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
      ForEach(columnGuide) { columnInfo in
        
        VStack {
          ZStack {
            Rectangle()
              .fill(Color.tableTitle)
            Text(columnInfo.title)
              .styleTableText()
          }
          
          ForEach(data) { rowData in
            
            ZStack {
              Rectangle()
                .fill(Color.labelReversed)
              Text(rowData[keyPath: columnInfo.value])
                .styleTableText()
                .lineLimit(8)
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

struct CustomTableColumn<T>: Hashable, Identifiable {
  var title: String
  var value: KeyPath<T, String>
  var id = UUID()
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

// MARK: - ViewModifier

private struct CustomTableTextModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .frame(alignment: .leading)
      .padding(4)
      .foregroundColor(Color.label)
      .minimumScaleFactor(0.2)
  }
}

private extension Text {
  func styleTableText() -> some View {
    modifier(CustomTableTextModifier())
  }
}
