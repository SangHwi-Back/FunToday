//
//  FunTodayTests.swift
//  FunTodayTests
//
//  Created by 백상휘 on 2023/04/27.
//

import XCTest

final class FunTodayTests: XCTestCase {
  func test_diskStore() throws {
    // Arrange
    var sut = TDiskStore(0)
    sut.willReturn(1)
    
    // Act
    for _ in 1...4 {
      sut.save(data: Data())
    }
    
    // Assert
    XCTAssertTrue(sut.verify({
      let res = $0.loadAll().count
      print("Test Result ::: \(res)")
      return res
    }))
  }
}
