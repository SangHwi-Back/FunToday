//
//  AppWrapper.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/16.
//

import SwiftUI

//@main
struct AppWrapper {
  static func main() {
    UIApplicationMain(
      CommandLine.argc,
      CommandLine.unsafeArgv,
      nil,
      NSStringFromClass(SceneDelegate.self)
    )
  }
}
