//
//  FunTodayTab.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI

enum FunTodayTab: String {
  case goal, review, setting
  
  var thumbnailImage: Image {
    switch self {
    case .goal:
      return Image(systemName: "checklist")
    case .review:
      return Image(systemName: "doc.text.magnifyingglass")
    case .setting:
      return Image(systemName: "gearshape")
    }
  }
  
  var getText: Text {
    Text(self.rawValue.uppercased())
  }
  
  func getLabel() -> some View {
    VStack {
      thumbnailImage
      getText
    }
  }
//  func getLabel() -> Label<Text, Image> {
//    Label {
//      self.getText
//    } icon: {
//      self.thumbnailImage
//    }
//  }
}
