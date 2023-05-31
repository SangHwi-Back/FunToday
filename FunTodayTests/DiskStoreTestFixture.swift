//
//  DiskStoreTestFixture.swift
//  FunTodayTests
//
//  Created by 백상휘 on 2023/05/31.
//

import Foundation

final class TDiskStore: DiskStore, Mock {
  typealias VALUE = Int
  typealias T = DiskStore
  
  var result: VALUE
  var userDefaults = UserDefaults()

  init(_ res: VALUE) {
    self.result = res
  }

  override func getStorage() -> UserDefaults {
    return self.userDefaults
  }

  func verify(_ handler: (DiskStore) -> VALUE) -> Bool {
    
    return result == handler(self as DiskStore)
  }
}
