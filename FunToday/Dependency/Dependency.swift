//
//  Dependency.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/08.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

class DependencyFirebaseDB: ObservableObject {
  private(set) lazy var ref = Database.database().reference()
  
  init() {
    FirebaseApp.configure()
  }
}
