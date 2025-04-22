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
    @State private var isDataSelected: Bool = UserDefaults.standard.bool(forKey: "isDataSelected")
    
    
    var body: some Scene {
        WindowGroup {
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
