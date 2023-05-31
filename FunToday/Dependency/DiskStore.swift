//
//  DiskStore.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/29.
//

import Foundation

class DiskStore: StoreInKeyValueDependency {
  static let DP = DiskStore()
  let keyName = "Activities"
  
  func getStorage() -> UserDefaults {
    return UserDefaults.standard
  }
  
  func save(data: Data) {
    saveData(data, at: keyName)
  }
  
  func save(data: [Data]) {
    saveData(data, at: keyName)
  }
  
  func save(name: String, data: Data) {
    saveData(data, at: addContextPath([name], after: keyName))
  }
  
  func save(name: String, data: [Data]) {
    saveData(data, at: addContextPath([name], after: keyName))
  }
  
  func save(contextPath: [String], data: Data) {
    saveData([data], at: addContextPath(contextPath, after: keyName))
  }
  
  func save(contextPath: [String], data: [Data]) {
    saveData(data, at: addContextPath(contextPath, after: keyName))
  }
  
  func load(name: String) -> [Data] {
    loadData(at: keyName + "/" + name)
  }
  
  func load(contextPath: [String]) -> [Data] {
    loadData(at: addContextPath(contextPath, after: keyName))
  }
  
  func loadAll() -> [Data] {
    loadData(at: keyName)
  }
  
  private func saveData(_ data: [Data], at path: String) {
    getStorage().set(data, forKey: path)
  }
  
  private func saveData(_ data: Data, at path: String) {
    getStorage().set(data, forKey: path)
  }
  
  private func loadData(at path: String) -> [Data] {
    let ret = getStorage().object(forKey: path)
    
    if let ret = ret as? Data {
      return [ret]
    }
    else if let ret = ret as? [Data] {
      return ret
    }
    else {
      return []
    }
  }
}

extension DiskStore {
  func addContextPath(_ contextPath: [String], after name: String) -> String {
    ([keyName] + contextPath)
      .reduce("", {$0 + "/" + $1})
  }
}
