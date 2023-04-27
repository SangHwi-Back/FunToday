//
//  PriorityQueue.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import Foundation

class PriorityQueue<Element: Comparable> {
  
  var items: [Element] = []
  var sort: (Element, Element) -> Bool = {
    $0 < $1
  }
  
  var leftIndex: (Int) -> Int = { ($0 * 2) + 1 }
  var rightIndex: (Int) -> Int = { ($0 * 2) + 2 }
  var parentIndex: (Int) -> Int = {
    guard $0 > 0 else { return 0 }
    return ($0 - 1) / 2
  }
  
  private func siftUp(_ index: Int) {
    var child = index, parent = parentIndex(index)
    
    while child > 0, sort(items[child], items[parent]) {
      items.swapAt(child, parent)
      child = parent
      parent = parentIndex(child)
    }
  }
  
  private func siftDown(_ index: Int) {
    var parent = index, candidate = 0
    
    while true {
      let lh = leftIndex(index), rh = rightIndex(index)
      candidate = parent
      
      if lh < items.count, sort(items[lh], items[candidate]) {
        candidate = lh
      }
      if rh < items.count, sort(items[rh], items[candidate]) {
        candidate = rh
      }
      if candidate == parent {
        return
      }
      items.swapAt(parent, candidate)
      parent = candidate
    }
  }
  
  func enqueue(_ item: Element) {
    items.append(item)
    siftUp(items.count - 1)
  }
  func dequeue() -> Element? {
    guard items.isEmpty == false else { return nil }
    return items.removeLast()
  }
}
