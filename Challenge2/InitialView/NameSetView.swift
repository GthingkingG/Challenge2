//
//  NameSetView.swift
//  Challenge2
//
//  Created by Air on 4/21/25.
//

import SwiftUI
import SwiftData

struct NameSetView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var name: String = ""
    var selectedType: myType
   
    
    var body: some View {
        NavigationStack {
            //확인버튼_네비게이션링크
            VStack {
                NavigationLink(destination: MainView()) {
                    Text("Done")
                }
                .offset(x: 140 ,y: 40)//뷰의 위치 설정
                .padding()
                
                
                Spacer().frame(height: 140)
                
                //프로필(이름)
                ZStack {
                    Circle()
                        .fill(selectedType.typeColor)
                        .opacity(0.5)
                        .frame(width: 240, height: 240)
                    Text(name)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                        .lineLimit(1)//문장을 한 줄로 제한
                        .minimumScaleFactor(0.5)//50%까지 글자크기를 글자 개수에 따라 변경
                        .frame(width: 200)
                }
                .padding(24)
                
                
                //이름입력칸
                HStack {
                    TextField("Name", text: $name)
                        .font(.title3.bold())
                        .padding(.horizontal, 36)
                }
                .background(
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 320, height: 44)
                        .cornerRadius(16)
                )
                .padding()
                Spacer()
            }
        }
        .navigationTitle("NameSet")
        .onDisappear() {
            //이 창이 닫히면서 실행
            
            //이름과 전달받은 타입 SwiftData에 저장
            saveInfo()
            
            //UserDefaults에 데이터 선택 기록 저장
            UserDefaults.standard.set(true, forKey: "isDataSelected")

        }
        
    }
    //새로운 UserInfo생성자를 만들어서, newUser에 저장하고, modelContext배열에 인서트한 후, 저장
    private func saveInfo() {
        let newUser = UserInfo(userName: name, userType: selectedType, memos: [])
            modelContext.insert(newUser)
        do {
            try modelContext.save()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    NameSetView(selectedType: .basil)
}
