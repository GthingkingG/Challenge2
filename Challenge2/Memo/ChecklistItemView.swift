//
//  ChecklistItemView.swift
//  Challenge2
//
//  Created by Air on 4/17/25.
//
import SwiftUI

struct ChecklistItemView: View {
    @Binding var item: ChecklistItem
    
    var body: some View {
        HStack {
            Image(systemName: item.isChecked ? "checkmark.square.fill" : "square")
                .foregroundColor(item.isChecked ? .blue : .primary)
                .onTapGesture {
                    item.isChecked.toggle()
                }
            TextField("checklist item", text: $item.checklistTitle)
                .textFieldStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
