//
//  ContentView.swift
//  Challenge2
//
//  Created by Air on 4/15/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Memo.modifiedAt, order: .reverse) private var memos: [Memo]
    @State private var searchText = ""
    @State private var isAddingNewMemo = false
    @State private var showingDeleteConfirm = false
    @State private var memoToDelete: Memo?
    
    var filteredMemos: [Memo] {
        if searchText.isEmpty {
            return memos
        } else {
            return memos.filter { memo in
                memo.title.localizedCaseInsensitiveContains(searchText) ||
                memo.content.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
                List {
                    ForEach(filteredMemos) { memo in
                        NavigationLink(destination: MemoDetailView(memo: memo)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(memo.title)
                                        .font(.system(size: 17))
                                        .lineLimit(1)
                                    
                                    Text(formatDate(memo.modifiedAt))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 4)
                                Spacer()
                                Text("Detail")
                                    .foregroundStyle(Color.secondary)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        if let index = indexSet.first {
                            memoToDelete = filteredMemos[index]
                            showingDeleteConfirm = true
                        }
                    }
                }
                .navigationTitle("Reflection")
                .searchable(text: $searchText, prompt: "Search")
                .sheet(isPresented: $isAddingNewMemo) {
                    NewMemoView()
                }
                .confirmationDialog(
                    "이 메모를 삭제하시겠습니까?",
                    isPresented: $showingDeleteConfirm,
                    titleVisibility: .visible
                ) {
                    Button("삭제", role: .destructive) {
                        if let memo = memoToDelete {
                            deleteMemo(memo)
                        }
                    }
                    Button("취소", role: .cancel) {}
                }
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        HStack {
                            Text("\(filteredMemos.count) reflections")
                                .font(.system(size: 15, weight: .light))
                                
                            Button(action: {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                isAddingNewMemo = true
                            }) {
                                Image(systemName: "square.and.pencil")
                                    .font(.title3.weight(.semibold))
                                    .frame(width: 44, height: 44)
                                    .background(Color.white)
                                    .foregroundColor(.blue)
                            }
                        }

                    }
                }
                .toolbarBackground(.white, for: .bottomBar)
                .toolbarBackground(.visible, for: .bottomBar)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
    
    private func deleteMemo(_ memo: Memo) {
        modelContext.delete(memo)
        memoToDelete = nil
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.d"
        return formatter.string(from: date)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Memo.self, configurations: config)
    
    // 샘플 데이터 추가
    let sampleMemo1 = Memo(title: "쇼핑 목록",
                          content: "1. 우유\n2. 빵\n3. 계란",
                          createdAt: Date().addingTimeInterval(-86400),
                          modifiedAt: Date().addingTimeInterval(-3600))
    
    let sampleMemo2 = Memo(title: "회의 안건",
                          content: "1. 프로젝트 현황\n2. 다음 마일스톤\n3. 질문 및 토론",
                          createdAt: Date().addingTimeInterval(-172800),
                          modifiedAt: Date().addingTimeInterval(-86400))
    
    container.mainContext.insert(sampleMemo1)
    container.mainContext.insert(sampleMemo2)

    
    return ContentView()
        .modelContainer(container)
}
