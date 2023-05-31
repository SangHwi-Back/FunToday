//
//  MockAndStub.swift
//  FunTodayTests
//
//  Created by 백상휘 on 2023/05/31.
//

import Foundation

/// Conform this **Mock** when test the SUT(System-Under-Test)'s Out-Bound value.
protocol Mock {
  associatedtype VALUE: Comparable
  associatedtype T
  var result: VALUE { get set }
  func verify(_ handler: (T) -> VALUE) -> Bool
}

extension Mock {
  mutating func willReturn(_ res: VALUE) {
    result = res
  }
}

protocol Stub {
  associatedtype TestResult
  var _mock: any Mock { get set }
}

extension Stub {
  mutating func toStubEnabled(_ mock: any Mock) -> Self {
    self._mock = mock
    return self
  }
}
