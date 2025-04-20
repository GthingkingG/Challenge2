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
    
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isContentFocused: Bool
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Title", text: $title)
                    .font(.largeTitle.bold())
                    .padding(.horizontal)
                    .focused($isTitleFocused)
                    .submitLabel(.next)
                    .onSubmit {
                        isContentFocused = true
                    }
                
                TextEditor(text: $content)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .focused($isContentFocused)
                
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
        .onAppear {
            isTitleFocused = true
        }
    }
    
    private func saveMemo() {
        let now = Date()
        // 제목이 비어있으면 내용의 첫 부분을 제목으로 사용
        let finalTitle = title.isEmpty ?
            (content.isEmpty ? "New Reflection" : String(content.prefix(20))) :
            title
        
        do {
            let newMemo = Memo(title: finalTitle, content: content, createdAt: now, modifiedAt: now, customDate: now)
            
            modelContext.insert(newMemo)
            try modelContext.save()
        }
        catch {
            print("error : \(error.localizedDescription)")
        }
            
        
        dismiss()
    }
}

#Preview {
    NewMemoView()
        .modelContainer(for: Memo.self, inMemory: true)
}
