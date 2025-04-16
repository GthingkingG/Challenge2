//
//  Memo.swift
//  Challenge2
//
//  Created by Air on 4/16/25.
//

import SwiftData
import Foundation

@Model
class Memo {
    var title: String
    var content: String
    var createdAt: Date
    var modifiedAt: Date
    
    init(title: String, content: String, createdAt: Date = Date(), modifiedAt: Date = Date()) {
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }
}
