//
//  FileDependency.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/29.
//

import Foundation

protocol StoreInKeyValueDependency {
  var keyName: String { get }
  
  /// Overwrite data at keyName
  ///
  /// - Parameters:
  ///    - data: Data to store
  func save(data: Data)
  
  /// Overwrite data at keyName
  ///
  /// - Parameters:
  ///    - data: Data to store
  func save(data: [Data])
  
  /// Overwrite data at keyName
  ///
  /// - Parameters:
  ///    - name: name appending to key name
  ///    - data: Data to store
  func save(name: String, data: Data)
  
  /// Load all data using keyName
  ///
  /// - Parameters:
  ///    - name: name appending to key name
  ///    - data: Data to store
  func save(name: String, data: [Data])
  
  /// Overwrite data at keyName
  ///
  /// - Parameters:
  ///    - contextPath: paths appending to key name
  ///    - data: Data to store
  func save(contextPath: [String], data: Data)
  
  /// Overwrite data at keyName
  ///
  /// - Parameters:
  ///    - contextPath: paths appending to key name
  ///    - data: Data to store
  func save(contextPath: [String], data: [Data])
  
  /// Get all data using keyName
  ///
  /// - Parameters:
  ///    - name: paths appending to key name
  func load(name: String) -> [Data]
  
  /// Get all data using keyName
  ///
  /// - Parameters:
  ///    - contextPath: paths appending to key name
  func load(contextPath: [String]) -> [Data]
  
  /// Get all data using keyName
  func loadAll() -> [Data]
}
