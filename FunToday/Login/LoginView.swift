//
//  LoginView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/06/24.
//
import SwiftUI
import ComposableArchitecture

struct LoginView: View {
  let store: StoreOf<LoginFeature>
  
  var body: some View {
    WithViewStore(store) { viewstore in
      VStack {
        CommonTextField(
          capImage: nil,
          isSecure: false,
          placeHolder: "아이디",
          text: viewstore.binding(
            get: \.id,
            send: LoginFeature.Action.setId))
        CommonTextField(
          capImage: Image(systemName: "lock"),
          isSecure: true,
          placeHolder: "비밀번호",
          text: viewstore.binding(
            get: \.password,
            send: LoginFeature.Action.setPassword))
        Spacer()
        Button("Login") {
          viewstore.send(.login)
        }
      }
      .padding()
      .alert(
        store.scope(
          state: \.alertState,
          action: { _ in .showAlert(nil)} ),
        dismiss: .showAlert(nil))
    }
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    let state = UserState()
    var loginConfirmed = false
    
    return LoginView(store: Store(
      initialState: .init(),
      reducer: { LoginFeature(loginConfirmed: Binding.constant(loginConfirmed)) }))
  }
}
