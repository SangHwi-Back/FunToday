//
//  GoalInsertView.swift
//  FunToday
//
//  Created by 백상휘 on 2023/05/11.
//

import SwiftUI

struct GoalInsertView: View {
  @State var name: String = ""
  @State var desc: String = ""
  
  @State var routines: [Routine] = []
  @State var activeRoutine: Routine?
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) { VStack(spacing: 8) {
      VStack(spacing: 8) {
        
        // MARK: - Goal Section
        InputField(labels: [],
                   textField: CommonTextField(
                    title: "이름 :",
                    placeHolder: "(X)", text: $name))
        InputField(labels: [],
                   textField: CommonTextField(
                    title: "설명 :",
                    placeHolder: "(-)", text: $desc))
        
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

struct GoalInsertView_Previews: PreviewProvider {
  static var previews: some View {
    GoalInsertView()
  }
}
