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
    DiskStoreMockFixture(keyName: "Test").overwrite(data: [])
    DiskStoreStubFixture(keyName: "Test").overwrite(data: [])
  }
  
  func test_diskStoreMock() throws {
    // Arrange
    var sut = DiskStoreMockFixture(keyName: "Test")
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
    var sut = DiskStoreStubFixture(keyName: "Test")
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
  
  @MainActor
  func test_goalListReducer() async throws {
    let store = TestStore(initialState: GoalListFeature.State(goalList: .init())) {
      GoalListFeature()
    }
    
    await store.send(.setList)
    
    XCTAssertEqual(store.state.goalList.count, GoalStore.DP.loadAll().count)
  }
  
  @MainActor
  func test_routineListReducer() async throws {
    let store = TestStore(initialState: RoutineInputFeature.State(routine: Routine.getDouble())) {
      RoutineInputFeature()
    }
    
    await store.send(.updateName("Unit Test Routines")) {
      $0.routine.name = "Unit Test Routines"
    }
    
    await store.send(.updateDescription("Unit Test Routine Description Inputs")) {
      $0.routine.description = "Unit Test Routine Description Inputs"
    }
    
    await store.send(.activityContainerElement(action: .addActivity))

    XCTAssertEqual(store.state.containerState.activities.count, 1)
  }
  
  @MainActor
  func test_activityContainerReducer() async throws {
    let preset = Activity.getDouble()
    let inputState = ActivityInputFeature.State(activity: Activity.getDouble(inx: 1))
    let store = TestStore(initialState: ActivityContainerFeature.State(
      activities: IdentifiedArrayOf(arrayLiteral: inputState),
      presetActivity: .init(list: []))) {
        ActivityContainerFeature()
      }
    
    await store.send(.presetElement(action: .rowSelected(preset)))
    
    XCTAssertEqual(store.state.activities.count, 2)
    
    await store.send(.presetElement(action: .rowSelected(inputState.activity)))
    await store.send(.activityElement(id: inputState.id, action: .removeActivity))
    
    XCTAssertEqual(store.state.activities.count, 2)
  }
}
