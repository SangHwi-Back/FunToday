//
//  FunTodayTests.swift
//  FunTodayTests
//
//  Created by 백상휘 on 2023/04/27.
//

import XCTest

final class FunTodayTests: XCTestCase {
  override func setUp() async throws {
    DiskStoreTestFixture().overwrite(data: [])
  }
  
  func test_diskStore() throws {
    // Arrange
    var sut = DiskStoreTestFixture()
    sut.willReturn(4)
    
    // Act
    for _ in 1...4 {
      sut.save(data: Data())
    }
    
    // Assert
    XCTAssertTrue(sut.verify({ $0.loadAll().count }))
  }
}
