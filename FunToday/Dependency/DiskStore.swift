//
//  DiskStore.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/29.
//

import Foundation

class DiskStore: StoreInKeyValueDependency {
  lazy var path: (String) -> String = {
    if $0.isEmpty {
      return self.keyName
    } else {
      return self.keyName + "/" + $0
    }
  }
  
  let keyName: String
  
  init(keyName: String) {
    self.keyName = keyName
  }
  
  func getStorage() -> UserDefaults {
    return UserDefaults.standard
  }
  
  func save(at name: String = "", data: Data) {
    let store = loadData(at: path(name)) + [data]
    saveData(store, at: path(name))
  }
  func overwrite(at name: String = "", data: Data) {
    saveData(data, at: path(name))
  }
  
  func save(at name: String = "", data: [Data]) {
    let store = loadData(at: path(name)) + data
    saveData(store, at: path(name))
  }
  func overwrite(at name: String = "", data: [Data]) {
    saveData(data, at: path(name))
  }
  
  func load(at name: String = "") -> [Data] {
    loadData(at: path(name))
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

class ActivityStore: DiskStore {
  static let DP = ActivityStore(keyName: "Activities")
}

class GoalStore: DiskStore {
  static let DP = GoalStore(keyName: "Goals")
}
