//
//  SettingView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
      GeometryReader { proxy in
        NavigationView {
          List
          {
            Section {
              Text("Users")
              SettingRow(text: "로그아웃")
              SettingRow(text: "개인정보 보호 동의 내역")
            }
            
            Section {
              Text("Contents")
              SettingRow(text: "리뷰")
              SettingRow(text: "활동 프리셋")
            }
          }
        }
      }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

struct SettingRow: View {
  var text: String
  var body: some View {
    HStack {
      Text(text)
      Spacer()
    }
    .padding(.horizontal, 8)
  }
}
