//
//  SettingView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import SwiftUI
import ComposableArchitecture

struct SettingView: View {
  var body: some View {
    List {
      Section(header: Text("사용자")) {
        NavigationLink { InstructionView() } label: {
          Text("사용 방법")
        }
      }
      
      Section(header: Text("내용 및 데이터")) {
        NavigationLink { SettingReviewInShortView() } label: {
          Text("리뷰 요약화면 설정")
        }
        NavigationLink { SettingReviewView() } label: {
          Text("리뷰화면 설정")
        }
        NavigationLink {
          SettingActivityPresetView(store: Store(
            initialState: SettingActivityPresetFeature.State(
              activities: .init(),
              newActivity: .init(activity: Activity.getDouble())),
            reducer: {
              SettingActivityPresetFeature()
            }))
        } label: {
          Text("활동 프리셋")
        }
      }
    }
    .navigationBarHidden(true)
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle("설정")
  }
}

struct SettingView_Previews: PreviewProvider {
  static var previews: some View {
    SettingView()
  }
}
