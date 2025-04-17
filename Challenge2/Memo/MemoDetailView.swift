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
    @State private var showingDatePicker = false
    @State private var isShowingAlignmentPopover = false

    
    private var currentAlignment: TextAlignment {
            switch memo.textAlignment {
            case 1: return .center
            case 2: return .trailing
            default: return .leading
            }
        }
    
    var body: some View {
        VStack(spacing: 0) {
            if isEditing {
                TextField("Title", text: $memo.title)
                    .font(.largeTitle.bold())
                    .padding(.horizontal)
                    .padding(.top)
                
                
                TextEditor(text: $memo.content)
                    .multilineTextAlignment(currentAlignment)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                
                List {
                    ForEach($memo.checkboxes) { $item in
                        ChecklistItemView(item: $item)
                    }
                    .onDelete(perform: deleteChecklistItem)
                }
                .listStyle(.plain)
                .frame(maxHeight: 200)
                
                
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(memo.title)
                            .font(.largeTitle.bold())
                            .padding(.horizontal)
                        Text(memo.content)
                            .multilineTextAlignment(currentAlignment)
                            .padding(.horizontal, 25)
                            .padding(.bottom, 50)
                        
                            
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                    
                }
                
            }
            
            if !isEditing && !memo.content.isEmpty {
                List(memo.checkboxes) { item in
                    HStack {
                        Image(systemName: item.isChecked ? "checkmark.square.fill" : "square")
                            .foregroundColor(item.isChecked ? .blue : .primary)
                        Text(item.checklistTitle)
                    }
                }
                .listStyle(.plain)
                .frame(maxHeight: 160)
            }
            
            
            if isEditing {
                HStack{
                    //체크박스
                    Button(action: insertChecklist) {
                        Image(systemName: "checkmark.square")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    
                    // 첨부파일 버튼
                    Button(action: {}) {
                        Image(systemName: "paperclip")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    // 정렬 선택 메뉴
                    Button {
                        isShowingAlignmentPopover = true
                    } label: {
                        Image(systemName: "text.alignleft")
                            .font(.title2)
                            .foregroundColor(isShowingAlignmentPopover ? .secondary : .blue)
                    }
                    .popover(isPresented: $isShowingAlignmentPopover, arrowEdge: .bottom) {
                        HStack {
                            Button(action: {
                                memo.textAlignment = 3
                                isShowingAlignmentPopover = false
                            }) {
                                Image(systemName: "text.alignleft")
                                    .font(.title2)
                                    .foregroundColor(memo.textAlignment == 3 ? .blue : .primary)
                                    .frame(width: 44, height: 44)
                                    .contentShape(Rectangle())
                            }
                            Button(action: {
                                memo.textAlignment = 1
                                isShowingAlignmentPopover = false
                            }) {
                                Image(systemName: "text.aligncenter")
                                    .font(.title2)
                                    .foregroundColor(memo.textAlignment == 1 ? .blue : .primary)
                                    .frame(width: 44, height: 44)
                                    .contentShape(Rectangle())
                            }
                            Button(action: {
                                memo.textAlignment = 2
                                isShowingAlignmentPopover = false
                            }) {
                                Image(systemName: "text.alignright")
                                    .font(.title2)
                                    .foregroundColor(memo.textAlignment == 2 ? .blue : .primary)
                                    .frame(width: 44, height: 44)
                                    .contentShape(Rectangle())
                            }
                        }
                        .padding(12)
                        .presentationCompactAdaptation(.popover)
                    }
                    Spacer()
                    
                    // 날짜 설정 버튼
                    Button(action: { showingDatePicker = true }) {
                        Image(systemName: "calendar")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .frame(maxWidth: .infinity)
                .background(
                    Rectangle()
                        .fill(Color(.systemBackground))
                        .edgesIgnoringSafeArea(.bottom)
                        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: -2)
                )
                .overlay(Divider(), alignment: .top)
                
            }
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
        .sheet(isPresented: $showingDatePicker) {
            DatePicker(
                "날짜 선택",
                selection: Binding(
                    get: { memo.customDate ?? Date() },
                    set: { memo.customDate = $0 }
                ),
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.graphical)
            .presentationDetents([.height(400)])
            .labelsHidden()
            .padding()
        }
    }
        
    

    private var alignmentIcon: String {
            switch memo.textAlignment {
            case 1: return "text.aligncenter"
            case 2: return "text.alignright"
            default: return "text.alignleft"
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
    
    private func deleteChecklistItem(at offsets: IndexSet) {
        memo.checkboxes.remove(atOffsets: offsets)
        memo.modifiedAt = Date()
    }
    
    private func insertChecklist() {
        let newItem = ChecklistItem(checklistTitle: "New item")
        memo.checkboxes.append(newItem)
        memo.modifiedAt = Date()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Memo.self, ChecklistItem.self, configurations: config)
    
    let sampleMemo = Memo(
        title: "회의 안건",
        content: "1. 프로젝트 현황\n2. 다음 마일스톤",
        textAlignment: 0,
        checkboxes: [
            ChecklistItem(checklistTitle: "Task 1", isChecked: true),
            ChecklistItem(checklistTitle: "Task 2")
        ]
    )
    
    NavigationStack {
        MemoDetailView(memo: sampleMemo)
    }
    .modelContainer(container)
}
