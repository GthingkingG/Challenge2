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
    
    @Query private var memos: [Memo]
    
    
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
                                        .font(.system(size: 17, weight: .regular))
                                        .lineLimit(1)
                                    
                                    Text(formatDate(memo.customDate ?? memo.modifiedAt))
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(Color.secondary)
                                }
                                .padding(.vertical, 4)
                                Spacer()
                                Text("Detail")
                                    .foregroundStyle(.tertiary)
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
                    "Are you sure you want to delete this note?",
                    isPresented: $showingDeleteConfirm,
                    titleVisibility: .visible
                ) {
                    Button("Delete", role: .destructive) {
                        if let memo = memoToDelete {
                            deleteMemo(memo)
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        HStack {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 44, height: 44)
                            Spacer()
                            Text("\(filteredMemos.count) reflections")
                                .font(.system(size: 15, weight: .light))
                            Spacer()
                            Button(action: {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                isAddingNewMemo = true
                            }) {
                                Image(systemName: "square.and.pencil")
                                    .font(.title3.weight(.semibold))
                                    .frame(height: 44)
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
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    
}

#Preview {
    ContentView()
}
