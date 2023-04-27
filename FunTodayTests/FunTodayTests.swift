//
//  FunTodayTests.swift
//  FunTodayTests
//
//  Created by 백상휘 on 2023/04/27.
//

import XCTest

final class FunTodayTests: XCTestCase {
  let data = [
    5,4,8,19,1,3,2,7,3
  ]
  
  func test_queue() throws {
    let queue = PriorityQueue<Int>()
    
    measure {
      for _ in 0...200 {
        for datum in data {
          queue.enqueue(datum)
        }
      }
    }
  }
  
  func test_array() throws {
    measure {
      var arr = [Int]()
      for _ in 0...200 {
        for datum in data {
          arr.append(datum)
          arr.sort()
        }
      }
    }
  }
}
