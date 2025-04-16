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
    var textAlignment: Int
    
    init(title: String, content: String, createdAt: Date = Date(), modifiedAt: Date = Date(), textAlignment: Int = 0) {
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.textAlignment = textAlignment
    }
}
