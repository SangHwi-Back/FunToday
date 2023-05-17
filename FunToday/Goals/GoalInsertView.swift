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
    ScrollView(.vertical, showsIndicators: false) {
      VStack(spacing: 8) {
        
        // MARK: - Goal Section
        InputField(title: "이름 :", isEssential: true, text: $name)
        InputField(title: "설명 :", isEssential: false, text: $desc)
        
        // MARK: - Routines Section
        Text("루틴 \(routines.count)")
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.vertical)
        
        VStack(spacing: 8) {
          ForEach($routines) { routine in
            ZStack(alignment: .topLeading) {
              RoutineInputView(routine: routine)
              FloatingMinusButton(width: 24) {
                routines.removeAll(where: { $0 == routine.wrappedValue })
              }
                .offset(x: -24, y: -24)
            }
          }
          
          ZStack {
            RoundedRectangle(cornerRadius: 8)
              .strokeBorder(Color.gray)
            
            FloatingPlusButton(width: 24, bgColor: .gray) {
              routines.append(Routine.getDouble(inx: routines.count))
            }
          }
        }
      }.padding()
    }
    .navigationBarTitleDisplayMode(.large)
    .navigationTitle("목표 추가")
  }
}

struct GoalInsertView_Previews: PreviewProvider {
  static var previews: some View {
    GoalInsertView()
  }
}
