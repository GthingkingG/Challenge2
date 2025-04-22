//
//  ContentView.swift
//  Challenge2
//
//  Created by Air on 4/15/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    //SwitData에서 데이터를 Create, Update, Delete하기 위해 선언
    @Environment(\.modelContext) private var modelContext
    
    
    //쿼리는 read에 관여
    @Query private var memos: [Memo]
    
    //뷰에 바로 반영해야하는 변수는 상태변수로 선언
    @State private var searchText = ""
    @State private var isAddingNewMemo = false
    @State private var showingDeleteConfirm = false
    //메모가 있을 수도, 없을 수도 있어서 옵셔널 값으로 지정
    @State private var memoToDelete: Memo?
    
    
    //메모 필터링 함수, 제목과 본분에서 searchText와 동일한 내용포함되어있는 메모만 표시
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
        //네비게이션 링크를 사용하기 위해 네비게이션 스택 사용
        NavigationStack {
                List {
                    //반복문을 사용하여 필터된 메모들을 각각 네비게이션 링크로 선언
                    ForEach(filteredMemos) { memo in
                        NavigationLink(destination: MemoDetailView(memo: memo)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    //제목
                                    Text(memo.title)
                                        .font(.system(size: 17, weight: .regular))
                                        .lineLimit(1)
                                    //날짜
                                    Text(formatDate(memo.customDate ?? memo.modifiedAt))
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(Color.secondary)
                                }
                                .padding(.vertical, 4)
                                
                                Spacer()
                                //Detail텍스트
                                Text("Detail")
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        //리스트에서 메모 삭제
                        if let index = indexSet.first {
                            memoToDelete = filteredMemos[index]
                            showingDeleteConfirm = true
                        }
                    }
                }
                .navigationTitle("Reflection")
                .navigationBarTitleDisplayMode(.large)//네비게이션 제목 형식 고정
                .searchable(text: $searchText, prompt: "Searㅈch")//검색가능하도록
                .sheet(isPresented: $isAddingNewMemo) {
                    //NewMemoView가 시트로 올라오도록 설정
                    NewMemoView()
                }
                .confirmationDialog(
                    //삭제 경고 문구
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
                    //하단 바텀 툴바
                    ToolbarItemGroup(placement: .bottomBar) {
                        HStack {
                            //간격을 맞추기위해 투명블럭
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 44, height: 44)
                            
                            
                            Spacer()
                            
                            
                            //메모개수
                            Text("\(filteredMemos.count) reflections")
                                .font(.system(size: 15, weight: .light))
                            
                            
                            Spacer()
                            
                            
                            //새로운 메모 작성 버튼
                            Button(action: {
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
                //툴바 색 조정, 하단 전체에 색 입히기위해 안전영역 무시
                .toolbarBackground(.white, for: .bottomBar)
                .toolbarBackground(.visible, for: .bottomBar)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
    
    //메모 삭제 함수
    private func deleteMemo(_ memo: Memo) {
        modelContext.delete(memo)
        memoToDelete = nil
    }
    
    //날짜를 형식에 맞춰서 변경
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    
}

#Preview {
    ContentView()
}
