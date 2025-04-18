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
    var textAlignment: Int?
    
    var customDate: Date?
    
    var attachments: [Attachment]
    
    init(title: String, content: String, createdAt: Date = Date(), modifiedAt: Date = Date(), textAlignment: Int = 3, customDate: Date? = nil, attachments: [Attachment] = []) {
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.textAlignment = textAlignment
        self.customDate = customDate
        self.attachments = attachments
    }
}


@Model
class Attachment: Identifiable {
    var id = UUID()
    var fileName: String
    var fileURL: String
    var type: String
    
    init(fileName: String, fileURL: String, type: String) {
        self.fileName = fileName
        self.fileURL = fileURL
        self.type = type
    }
}
