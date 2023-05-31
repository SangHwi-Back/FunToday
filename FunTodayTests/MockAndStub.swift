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
  mutating func mockReturns(_ res: VALUE) {
    result = res
  }
}

protocol Stub {
  associatedtype VALUE: Comparable
  associatedtype TARGET
  var result: VALUE { get set }
  var stubTarget: TARGET? { get set }
  func verify() -> Bool
}

extension Stub {
  mutating func setUp(_ target: TARGET) {
    stubTarget = target
  }
  
  mutating func stubReturns(_ res: VALUE) {
    result = res
  }
}
