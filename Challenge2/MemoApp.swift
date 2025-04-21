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
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(for: [Memo.self])
        }
    }
}
