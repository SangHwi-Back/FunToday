//
//  LoginFeature.swift
//  FunToday
//
//  Created by 백상휘 on 2023/06/24.
//
import Foundation
import SwiftUI
import ComposableArchitecture

struct LoginFeature: ReducerProtocol {
  
  @Binding var loginConfirmed: Bool
  
  // MARK: - For Test (Start)
  var predefinedID = "Test"
  var predefinedPassWord = "12!@qwQW"
  // MARK: - For Test (End)
  
  struct State: Equatable {
    var id = "", password = ""
    
    var loginConfirmed = false
    var isAlreadyLogin = false
    
    var alertState: AlertState<Action>?
    
    static func == (lhs: LoginFeature.State, rhs: LoginFeature.State) -> Bool {
      lhs.id == rhs.id && lhs.password == rhs.password
    }
  }
  
  enum Action {
    case setId(String)
    case setPassword(String)
    case showAlert(Errors?)
    case login
  }
  
  enum Errors: Error {
    case idLength, passwordLength, whiteSpaceNotAllowed, passwordDiversity, wrongInfo, unknown
    
    static func validate(keyPath: KeyPath<LoginFeature.State, String>, value: String) -> Self? {
      guard value.contains(where: {Character(" ") == $0}) == false else {
        return .whiteSpaceNotAllowed
      }
      
      switch keyPath {
      case \.id:
        guard value.count >= 4 else { return .idLength }
        return nil
      case \.password:
        guard value.count >= 8 else { return .passwordLength }
        // https://ios-development.tistory.com/591
        let predicate = NSPredicate(
          format: "SELF MATCHES %@",
          "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}")
        
        return predicate.evaluate(with: value) ? nil : .passwordDiversity
      default:
        return .unknown
      }
    }
    
    func getAlertState() -> AlertState<Action> {
      let button = ButtonState<Action>(action: .showAlert(nil), label: { TextState("확인") })
      
      switch self {
      case .idLength:
        return AlertState(title: "ID 에러", message: "ID 는 5 자 이상입니다.", dismissButton: button)
      case .passwordLength:
        return AlertState(title: "Password 에러", message: "Password 는 8 자 이상입니다.", dismissButton: button)
      case .passwordDiversity:
        return AlertState(title: "Password 에러", message: "Password 에는 특수문자, 영어 대소문자가 포함되어야 합니다.", dismissButton: button)
      case .whiteSpaceNotAllowed:
        return AlertState(title: "잘못된 로그인 정보", message: "공백은 포함할 수 없습니다", dismissButton: button)
      case .wrongInfo:
        return AlertState(title: "잘못된 로그인 정보", message: "잘못된 로그인 정보를 입력하였습니다.", dismissButton: button)
      case .unknown:
        return AlertState(title: "ID 에러", message: "ID 는 5 자 이상입니다.", dismissButton: button)
      }
    }
  }
  
  var body: some ReducerProtocol<State, Action> {
    
    Reduce { state, action in
      switch action {
      case .setId(let id):
        state.id = id
        return .none
      case .setPassword(let password):
        state.password = password
        print(state.password)
        return .none
      case .showAlert(let alert):
        state.alertState = alert?.getAlertState()
        return .none
      case .login:
        if let alert = Errors.validate(keyPath: \.password, value: state.password)?.getAlertState() {
          state.alertState = alert
          return .none
        }
        
        if let alert = Errors.validate(keyPath: \.id, value: state.id)?.getAlertState() {
          state.alertState = alert
          return .none
        }
        
        guard predefinedID == state.id && predefinedPassWord == state.password else {
          state.alertState = Errors.wrongInfo.getAlertState()
          return .none
        }
        
        loginConfirmed = true
        state.loginConfirmed = true
        print(loginConfirmed, state.loginConfirmed)
        return .none
      }
    }
  }
}

private extension AlertState {
  init(title: String, message: String, dismissButton: ButtonState<Action>) {
    self.init(title: TextState(title), message: TextState(message), dismissButton: dismissButton)
  }
}
