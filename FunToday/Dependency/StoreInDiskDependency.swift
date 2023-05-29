//
//  StoreInDiskDependency.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/29.
//

import Foundation

protocol StoreInDiskDependency {
  var url: URL? { get }
  
  /// Save data in Disk
  ///
  /// - Parameters:
  ///    - data: Data to store
  func save(data: Data)
  
  /// Save data in Disk
  ///
  /// - Parameters:
  ///    - name: Directory name in filepath
  ///    - data: Data to store
  func save(name: String, data: Data)
  
  /// Save data in Disk
  ///
  /// - Parameters:
  ///    - urlContextPath: Paths in filepath
  ///    - data: Data to store
  func save(urlContextPath: [String], data: Data)
  
  /// Load data from filePath URL
  func load() -> Data
  
  /// Load data from filePath URL
  ///
  /// - Parameters:
  ///    - name: Directory name in filepath
  func load(name: String) -> Data
  
  /// Load data from filePath URL
  ///
  /// - Parameters:
  ///    - urlContextPath: Paths in filepath
  func load(urlContextPath: [String]) -> Data
}
