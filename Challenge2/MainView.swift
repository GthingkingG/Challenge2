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
    var body: some View {
        
        let level = potLevel(count: memos.count)
        
        NavigationStack {
            VStack {
                    NavigationLink(destination: ProfileView()) {
                        HStack {
                            Spacer()
                            Text("One")
                                .foregroundStyle(.white)
                                .padding(40)
                                .background(
                                    Circle()
                                        .fill(Color.blue)
                                        .opacity(0.3)
                                        .frame(width: 45, height: 45)
                                )
                                
                        }
                    }
                Spacer()
                Image("\(level.imageName)")
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
    }
}

#Preview {
    MainView()
}
