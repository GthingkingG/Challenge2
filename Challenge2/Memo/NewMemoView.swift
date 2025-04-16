//
//  NewMemoView.swift
//  Challenge2
//
//  Created by Air on 4/16/25.
//

import SwiftUI
import SwiftData

struct NewMemoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var content = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Title", text: $title)
                    .font(.largeTitle.bold())
                    .padding()
                
                TextEditor(text: $content)
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("New Reflection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        saveMemo()
                    }
                    .disabled(title.isEmpty && content.isEmpty)
                }
            }
        }
    }
    
    private func saveMemo() {
        let now = Date()
        // 제목이 비어있으면 내용의 첫 부분을 제목으로 사용
        let finalTitle = title.isEmpty ?
            (content.isEmpty ? "New Reflection" : String(content.prefix(20))) :
            title
            
        let newMemo = Memo(title: finalTitle, content: content, createdAt: now, modifiedAt: now)
        modelContext.insert(newMemo)
        dismiss()
    }
}

#Preview {
    NewMemoView()
        .modelContainer(for: Memo.self, inMemory: true)
}
