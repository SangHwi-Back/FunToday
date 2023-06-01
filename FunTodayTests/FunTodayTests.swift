//
//  FunTodayTests.swift
//  FunTodayTests
//
//  Created by 백상휘 on 2023/04/27.
//

import XCTest
import ComposableArchitecture

final class FunTodayTests: XCTestCase {
  override func setUp() async throws {
    DiskStoreMockFixture().overwrite(data: [])
    DiskStoreStubFixture().overwrite(data: [])
  }
  
  func test_diskStoreMock() throws {
    // Arrange
    var sut = DiskStoreMockFixture()
    sut.mockReturns(4)
    
    // Act
    for _ in 1...4 {
      sut.save(data: Data())
    }
    
    // Assert
    XCTAssertTrue(sut.verify({ $0.loadAll().count }))
  }
  
  func test_diskStoreStub() throws {
    // Arrange
    var sut = DiskStoreStubFixture()
    sut.setUp(sut.loadAll)
    sut.stubReturns(4)
    
    // Act
    for _ in 1...4 {
      sut.save(data: Data())
    }
    
    // Assert
    XCTAssertTrue(sut.verify())
  }
  
  @MainActor
  func test_goalInputReducer() async throws {
    let store = TestStore(initialState: GoalInputFeature.State(goal: .getDouble(), routines: .init())) {
      GoalInputFeature()
    }
    
    await store.send(.setFold) {
      $0.goal.isFold = !$0.goal.isFold
    }
    
    XCTAssertFalse(store.state.goal.isFold)
  }
}
