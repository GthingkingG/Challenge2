//
//  MainView.swift
//  Challenge2
//
//  Created by Air on 4/21/25.
//

import SwiftUI
import SwiftData


enum potLevel: Int {
    case level0 = 0
    case level1 = 1
    case level2 = 2
    case level3 = 3
    
    init(count: Int) {
        let index = min(count / 4, 3)
        self.init(rawValue: index)!
    }
    
    var imageName: String {
        "Pot\(rawValue)"
    }
}

struct MainView: View {
    @Query(sort: \Memo.customDate, order: .reverse) private var memos: [Memo]
    
    let selectedType: myType
    @EnvironmentObject var userData: UserData
    
    var body: some View {

        
        let level = potLevel(count: memos.count)
        
        NavigationStack {
            VStack {
                NavigationLink(destination: ProfileView(selectedType: selectedType)) {
                        HStack {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(selectedType.typeColor)
                                    .opacity(0.5)
                                    .frame(width: 64, height: 64)
                                Text(userData.userName)
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
                Image(level.rawValue > 2 ? "\(level.imageName)_\(selectedType.rawValue)" : level.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width :160, height: 160)
                Spacer()
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
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    MainView(selectedType: .cherryTomatoes)
        .environmentObject(UserData())
}
