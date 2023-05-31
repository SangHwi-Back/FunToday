//
//  DiskStoreMockFixture.swift
//  FunTodayTests
//
//  Created by 백상휘 on 2023/05/31.
//

import Foundation

final class DiskStoreMockFixture: DiskStore, Mock {
  var result: Int = 0
  var userDefaults = UserDefaults()

  override func getStorage() -> UserDefaults {
    userDefaults
  }

  func verify(_ handler: (DiskStore) -> Int) -> Bool {
    result == handler(self as DiskStore)
  }
}
