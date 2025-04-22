//
//  Challenge2App.swift
//  Challenge2
//
//  Created by Air on 4/15/25.
//

import SwiftUI
import SwiftData

@main
struct MemoApp: App {
    @State private var isDataSelected: Bool = UserDefaults.standard.bool(forKey: "isDataSelected")//데이터 선택을 했는지, 유저디폴트에 저장
    
    
    var body: some Scene {
        WindowGroup {
            //데이터 저장 여부에 따라 뷰 다르게 표시
            if isDataSelected {
                MainView()
                    .modelContainer(for: [UserInfo.self])
            } else {
                DataSelectView()
                    .modelContainer(for: [UserInfo.self])
                    
            }
            
        }
        
    }
}
