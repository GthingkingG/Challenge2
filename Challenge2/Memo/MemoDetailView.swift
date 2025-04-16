//
//  MemoDetailView.swift
//  Challenge2
//
//  Created by Air on 4/16/25.
//

import SwiftUI
import SwiftData

struct MemoDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var memo: Memo
    @State private var isEditing = false
    @State private var showingDeleteConfirm = false
    
    var body: some View {
        VStack {
            if isEditing {
                TextField("Title", text: $memo.title)
                    .font(.largeTitle.bold())
                    .padding(.horizontal)
                
                TextEditor(text: $memo.content)
                    .cornerRadius(8)
                    .padding(.horizontal)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(memo.title)
                            .font(.largeTitle.bold())
                            .padding(.horizontal)
                        
                        Text(memo.content)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                }
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(isEditing)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing {
                    Button("Done") {
                        memo.modifiedAt = Date()
                        isEditing = false
                    }
                } else {
                    Button("Edit") {
                        isEditing = true
                    }
                }
            }
            
            if isEditing {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isEditing = false
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive, action: {
                        showingDeleteConfirm = true
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    Button(action: shareMemo) {
                        Label("Upload", systemImage: "square.and.arrow.up")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .confirmationDialog(
            "Are you sure you want to delete this note?",
            isPresented: $showingDeleteConfirm,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                deleteMemo()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private func deleteMemo() {
        modelContext.delete(memo)
        dismiss()
    }
    
    private func shareMemo() {
        // 공유 기능 구현
        let shareContent = "\(memo.title)\n\n\(memo.content)"
        let activityVC = UIActivityViewController(activityItems: [shareContent], applicationActivities: nil)
        
        // UIWindow 찾기
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Memo.self, configurations: config)
    
    let sampleMemo = Memo(title: "회의 안건",
                         content: "1. 프로젝트 현황\n2. 다음 마일스톤\n3. 질문 및 토론")
    container.mainContext.insert(sampleMemo)
    
    return NavigationStack {
        MemoDetailView(memo: sampleMemo)
    }
    .modelContainer(container)
}
