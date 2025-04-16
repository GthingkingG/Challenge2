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
                TextField("제목", text: $memo.title)
                    .font(.largeTitle.bold())
                    .padding(.horizontal)
                
                TextEditor(text: $memo.content)
                    .cornerRadius(8)
                    .padding(.horizontal)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
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
                    Button("완료") {
                        memo.modifiedAt = Date()
                        isEditing = false
                    }
                } else {
                    Button("편집") {
                        isEditing = true
                    }
                }
            }
            
            if isEditing {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        isEditing = false
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive, action: {
                        showingDeleteConfirm = true
                    }) {
                        Label("삭제", systemImage: "trash")
                    }
                    
                    Button(action: shareMemo) {
                        Label("공유", systemImage: "square.and.arrow.up")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .confirmationDialog(
            "이 메모를 삭제하시겠습니까?",
            isPresented: $showingDeleteConfirm,
            titleVisibility: .visible
        ) {
            Button("삭제", role: .destructive) {
                deleteMemo()
            }
            Button("취소", role: .cancel) {}
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
