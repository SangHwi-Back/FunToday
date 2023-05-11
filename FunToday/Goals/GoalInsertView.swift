//
//  GoalInsertView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/11.
//

import SwiftUI

struct GoalInsertView: View {
  @State var id: String = ""
  @State var desc: String = ""
  
  @State var routines: [Routine] = []
  
  private lazy var states: [(String, Binding<String>)] = [
    ("(X)", $id),
    ("(-)", $desc),
  ]
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) { VStack(spacing: 8) {
      VStack(spacing: 8) {
        
        // MARK: - Goal Section
        InputField(labels: [],
                   textField: CommonTextField(
                    capImage: Image(systemName: "person"),
                    placeHolder: "(X)", text: $id))
        InputField(labels: [],
                   textField: CommonTextField(
                    capImage: Image(systemName: "text.alignleft"),
                    placeHolder: "(-)", text: $id))
        
        // MARK: - Routines Section
        HStack {
          Text("루틴 \(routines.count)")
            .frame(maxWidth: .infinity, alignment: .leading)
          FloatingPlusButton(width: 18) {
            routines.append(Routine.getDouble(inx: routines.count))
          }
        }
        
        VStack(spacing: 8) {
          ForEach($routines) { routine in
            RoutineInputView(routine: routine)
          }
        }
      }}.padding()
    }
  }
}

struct RoutineInputView: View {
  @Binding var routine: Routine
  
  var body: some View {
    CustomSectionView() {
      VStack(spacing: 4) {
        InputField(labels: [],
                   textField: CommonTextField(
                    capImage: Image(systemName: "person"),
                    placeHolder: "(X)", text: Binding.constant("")))
        
        // MARK: - Activities Section ( Inside of Routine)
        
        HStack {
          Text("활동")
            .frame(maxWidth: .infinity, alignment: .leading)
          FloatingPlusButton(width: 18) {
            routine.activities.append(Activity.getDouble(inx: routine.activities.count))
          }
        }
        
        ForEach($routine.activities) { activity in
          ActivityInputView(activity: activity)
        }
      }
    }
  }
}

struct ActivityInputView: View {
  @Binding var activity: Activity
  
  var body: some View {
    CustomSectionView {
      InputField(labels: [],
                 textField: CommonTextField(
                  capImage: Image(systemName: "person"),
                  placeHolder: "(X)", text: Binding.constant("")))
    }
  }
}

struct GoalInsertView_Previews: PreviewProvider {
  static var previews: some View {
    GoalInsertView()
  }
}
