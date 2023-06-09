# FunToday

> FunToday app project makes daily schedule for productive.<br/>
> 계획이란 것의 가장 중요한 것은 꾸준함과 달성입니다. 계획을 달성하는 경험을 제 애플리케이션을 통해 이루어 나가는 것이 이 애플리케이션을 개발한 목적입니다.

## 기획의도

* 계획을 수립, 수행에 부담감을 줄이도록 돕는 애플리케이션.
* 과중한 계획도 차근차근 도전하고 다음 계획을 세울 수 있도록 돕는다.
* 사용자를 위한 여러 컨텐츠를 제공할 예정.
  - 도움이 되는 (권위있는 사람들이 얘기한) 명언
  - 일러스트
  - gif

## FunToday 에서의 계획에 대한 정의

```none
┌─────────────────── 목표(Goal) ───────────────────┐
|   이루고 싶은 목표(ex. 꾸준히 운동하기, 독서를 많이 하기)   |
|  ┌───────────── 하루일과(Routine) ──────────────┐ |
|  | 루틴. 하루일과를 24 시간으로 저장함.               | |
|  | (ex. 운동 06:00 ~ 08:00, 업무 09:00 ~ 18:00) | |
|  | (ex. 독서 20:00 ~ 22:00, 수면 23:00 ~ 05:30) | |
|  |  ┌─────────── 활동(Activity) ────────────┐  | |
|  |  | 루틴의 단위. 시작,종료시간과 카테고리로 나뉨    |  | |
|  |  | * 활동 카테고리                         |  | |
|  |  |   - 건강앱과 연동되는 운동 계획             |  | |
|  |  |   - 집중 모드와 연동되는 독서, 집중          |  | |
|  |  |   - 완료여부와 종료시간만 존재하는 활동        |  | |
|  |  |   - 사용자 정의 활동                     |  | |
|  |  | 썸네일 이미지 jpg, gif 업로득 기능 제공      |  | |
└──└──└──────────────────────────────────────┘──┘─┘
```

## 기술스택

* Swift
* SwiftUI
* Swift Concurrency
* TCA
* Combine
* Firebase

## 배포환경

* iOS 14
* iPadOS 14

## Coding Convention

> 모든 Convention 은 상황에 따라 달라질 수 있습니다. Convention 에 의해 코드 가독성이 떨어지는 일은 없도록 합니다.

* 함수 호출 시 전달해야 할 파라미터가 3 개 이상이라면, 첫번째 파라미터 이후로는 줄바꿈으로 구분할 수 있도록 한다.
```swift
@State var name: String
InputField(title: "Name : ",
           isEssential: true,
           text: _name)
```

* ChildView 에게 자신의 Store 를 전달하는 경우, ChildView 의 액션에 반응하는 액션 타입 앞에는 `from` 을 붙인다.
```swift
struct TestFeature: ReducerProtocol {
  enum Action {
    case .updateName
    case .fromChildElement(id: ChildFeature.State.ID, action: ChildFeature.Action) // #1
  }
}
```
   * 위의 상황에서 Store 의 scope 함수를 사용하는 경우 한 줄에 적는다. (잘 읽어봐야 하는 내용이라는 의미로 특출나게 길게 적음)
   
     ```swift
     let store: StoreOf<TestFeature>
     // ...
     store.scope(state: \.entities, action: TestFeature.Action.fromChildElement(id:action:)) // #2 
     ```
     
* Feature(Reducer) 내부에 Action 을 나열할 때는 뷰 내부의 액션을 모두 나열한 후, ChildView 와 관련된 액션을 나열한다.
```swift
enum Action {
  csase .updateTextField
  case .buttonTapped
  case .switchTapped
  
  case .fromElements(id: ChildFeature.State.ID, action: ChildFeature.Action) // #1
}
```

* ViewStore 의 binding 함수를 사용하는 경우 다음과 같이 get, send 를 줄바꿈으로 분류한다.
```swift
viewstore.binding(
  get: \.name,
  send: TestFeature.Action.updateName)
```

## 개발 진행 순서

### Chapter 1

* 전체적인 뷰를 생성하며 반복되는 뷰는 재사용 가능한 코드로 생성
* TCA 적용을 통해 공통적인 개발 프로세스 정립
  - Unit-Test 작성.
  - Reducer 를 위한 Mock 인터페이스 정의를 위한 프로토콜 작업 진행.
  - 각 객체가 잘 캡슐화 된 단방향 아키텍처 사용예정이므로 런던파 테스트 진행 예정.
* 테스트 대역을 의존성으로서 주입하여 데이터를 대신함

### Chapter 2

* Firebase 로 최소 아래의 기능을 구현하고 의존성 주입
  - Database
  - Authentication
* 데이터는 나중에 Firebase Database 로 변경될 수 있음을 인지
* Reducer 는 테스트 타겟으로 설정하여 테스트 코드 작성하기
* "Sign in with Apple" 기능 활성화

### Chapter 3

* UI-Test 추가
* GitHub Action 을 통한 CI 기능 구현
  - Unit, UI-Test 를 통한 앱 안정성 증가
