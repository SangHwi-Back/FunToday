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
          ProgressCircle(status: Binding.constant(ProgressStatus.getDouble()))
          ProgressCircle(status: Binding.constant(ProgressStatus.getDouble()))
        }
        .padding(.horizontal)
        
        CustomTable<Routine, Any>(
          titles: ["","이름", "활동"],
          rows: Binding.constant([Routine.getDouble(), Routine.getDouble(inx: 1)]))
          .padding(.horizontal)
      }
    }
  }
}

struct ReviewView_Previews: PreviewProvider {
  static var previews: some View {
    ReviewView()
  }
}

struct CustomTable<Element, ContentsView>: View where Element: RowElement {
  
  var titles: [String]
  private var column: Int {
    titles.count
  }
  
  @Binding var rows: [Element]
  private var row: Int {
    rows.count
  }
  
  var body: some View {
    VStack(spacing: 4) { ForEach(0...row, id: \.self) { row in
      if row == 0 {
        LazyVGrid(columns: getGrid(columnCount: titles.count), spacing: 4) {
          ForEach(titles, id: \.self) { title in
            ZStack {
              if title.isEmpty == false {
                RoundedRectangle(cornerRadius: 8)
                  .stroke(.black, lineWidth: 1)
                Text(title)
              }
            }
          }
        }
        .padding(.horizontal, 4)
      } else {
        LazyVGrid(columns: getGrid(columnCount: column), spacing: 4) {
          ForEach(0..<column, id: \.self) { column in
            ZStack {
              RoundedRectangle(cornerRadius: 8)
                .stroke(.black, lineWidth: 1)
              rows[row-1].getColumns()
            }
          }
        }
        .padding(.horizontal, 8)
      }
    }}
    .padding(.vertical, 8)
    .overlay {
      RoundedRectangle(cornerRadius: 8)
        .stroke(.black, lineWidth: 1)
    }
  }
  
  private func getGrid(columnCount: Int) -> [GridItem] {
    return Array(
      repeating: GridItem(.flexible()),
      count: columnCount)
  }
}

protocol RowElement where ContentsView: View {
  associatedtype ContentsView
  func getColumns() -> ContentsView
}
