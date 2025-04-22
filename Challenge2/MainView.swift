//
//  MainView.swift
//  Challenge2
//
//  Created by Air on 4/21/25.
//

import SwiftUI
import SwiftData

//화분 레벨을 열거형으로 지정
enum potLevel: Int {
    case level0 = 0
    case level1 = 1
    case level2 = 2
    case level3 = 3
    
    
    //4개 씩 3단계로 설정, 4배수마다 이미지 케이스가 달라짐
    init(count: Int) {
        let index = min(count / 4, 3)
        self.init(rawValue: index)!
    }
    
    var imageName: String {
        "Pot\(rawValue)"
    }
}

struct MainView: View {
    //SwiftData에서 UserInfo와 Memo를 배열로 받아와서 각 변수에 저장하여 사용(쿼리는 읽기에 관여)
    @Query private var userInfos: [UserInfo]
    @Query private var memos: [Memo]
    
    var body: some View {
        //[UserInfo]배열에서 한 개의 객체만 사용하기 위해 반복문을 사용
        ForEach(userInfos) { userInfo in
            //메모의 개수를 레벨 인자로 사용
            let level = potLevel(count: memos.count)
            NavigationStack {
                VStack {
                    //프로필화면으로 가는 네비게이션 링크, 타입에 따라 배경색 변경, 이름 반영
                    NavigationLink(destination: ProfileView()) {
                            HStack {
                                Spacer()
                                ZStack {
                                    Circle()
                                        .fill(userInfo.userType.typeColor)
                                        .opacity(0.5)
                                        .frame(width: 64, height: 64)
                                    Text(userInfo.userName)
                                        .font(.title2.bold())
                                        .foregroundStyle(.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .frame(width: 60)
                                }
                                .padding(.horizontal, 32)
                                .padding(.vertical, 16)
                                    
                            }
                        }
                    
                    
                    Spacer()
                    
                    
                    //Asset에 이미지의 이름을 화분레벨로 저장하여, 변수명을 그대로 사용하고 마지막 레벨은 이미지가 모두 달라야해서 화분레벨_타입이름으로 저장하여 사용
                    Image(level.rawValue > 2 ? "\(level.imageName)_\(userInfo.userType.rawValue)" : level.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width :160, height: 160)
                    
                    
                    Spacer()
                    
                    
                    //메모리스트로 가는 네비게이션 링크, 메모의 개수 반영
                    HStack {
                        NavigationLink(destination: ContentView()) {
                            Text("Reflection: \(memos.count)")
                                .foregroundStyle(.white)
                                .frame(width: 240, height: 44)
                                .background(
                                    Capsule()
                                        .fill(Color.blue)
                                )
                        }
                    }
                    .frame(width: 402, height: 80)
                }
            }
            .navigationBarBackButtonHidden(true)//다음 뷰에서 뒤로 가는 버튼 가리기
            
        }
        
        
        
    }
}

#Preview {
    MainView()
    
}
