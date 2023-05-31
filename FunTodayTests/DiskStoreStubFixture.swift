//
//  DiskStoreStubFixture.swift
//  FunTodayTests
//
//  Created by 백상휘 on 2023/05/31.
//

import Foundation

final class DiskStoreStubFixture: DiskStore, Stub {
  var result: Int = 0
  var stubTarget: (() -> [Data])?
  
  func verify() -> Bool {
    (stubTarget ?? loadAll)().count == result
  }
}
