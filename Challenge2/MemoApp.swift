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
    @StateObject private var userData = UserData()
    let a = UserDefaults.standard.bool(forKey: "ss")
    
    var body: some Scene {
        WindowGroup {
            if a {
                MainView(selectedType: userData.userType ?? .greenOnions)
                    .modelContainer(for: [Memo.self])
                    .environmentObject(userData)
            } else {
                DataSelectView()
                    .modelContainer(for: [Memo.self])
                    .environmentObject(userData)
            }
            
        }
    }
}
