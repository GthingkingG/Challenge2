//
//  MemoDetailView.swift
//  Challenge2
//
//  Created by Air on 4/16/25.
//

import SwiftUI
import SwiftData
import _PhotosUI_SwiftUI

struct MemoDetailView: View {
    @Environment(\.modelContext) private var modelContext
    //화면닫기 위한 환경변수
    @Environment(\.dismiss) private var dismiss
    
    //ContentView에서 메모를 바인딩값으로 수령
    @Bindable var memo: Memo
    
    @State private var isEditing = false //편집 중인지 확인하는 변수
    @State private var showingDeleteConfirm = false //파일 삭제 확인 변수

    @State private var showingAttachmentOptions = false //첨부파일
    @State private var isShowingAlignmentPopover = false //정렬
    @State private var showingDatePicker = false //날짜설정
    
    //첨부파일_이미지 파일들
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    
    //텍스트 포맷
    @FocusState private var isEditorFocused: Bool
    @State private var showFormattingPanel = false
    @State private var isBold = false
    @State private var isItalic = false
    @State private var isUnderlined = false
    @State private var isStrikeThrough = false
    @State private var selectedColor: Color = .primary
    @State private var textStyle: Font.TextStyle = .body
    
    //스크롤 고정을 위한 변수
    private let titleID = "titleView"
    private let attachmentID = "attachmentView"
    
    //날짜 표시 변수
    @State private var isDateVisible = false
    
    //문장 정렬을 케이스로 나눠서 관리
    private var currentAlignment: TextAlignment {
        switch memo.textAlignment {
        case 1: return .center
        case 2: return .trailing
        default: return .leading
        }
    }
    
    var body: some View {
            VStack(spacing: 0) {
                //편집 중
                if isEditing {
                    Group {
                        //첨부파일 존재하면 표시
                        if !memo.attachments.isEmpty {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(memo.attachments) { attachment in
                                        AttachmentThumbnailView(
                                            attachment: attachment,
                                            isEditing: isEditing,
                                            onDelete: { deleteAttachment(attachment) }
                                        )
                                    }
                                }
                            }
                        }
                        //제목
                        TextField("Title", text: $memo.title)
                            .font(.largeTitle.bold())
                            .padding(.horizontal)
                            .padding(.top)
                        
                        
                        //본문
                        TextEditor(text: $memo.content)
                            .multilineTextAlignment(currentAlignment)
                            .font(.system(textStyle))
                            .bold(isBold)
                            .italic(isItalic)
                            .underline(isUnderlined)
                            .strikethrough(isStrikeThrough)
                            .foregroundStyle(selectedColor)
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .focused($isEditorFocused)
                            .disabled(showFormattingPanel)
                    }
                } else {//편집 중 X
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(alignment: .leading) {
                                
                                //날짜(처음엔 숨어있음)
                                Text(formattedCustomDate)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.horizontal)
                                    .opacity(isDateVisible ? 1 : 0)
                                
                                
                                //첨부파일
                                if !memo.attachments.isEmpty {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(memo.attachments) { attachment in
                                                AttachmentThumbnailView(
                                                    attachment: attachment,
                                                    isEditing: isEditing,
                                                    onDelete: { deleteAttachment(attachment) }
                                                )
                                                
                                            }
                                        }
                                        .padding(.horizontal, 8)
                                    }
                                    .id(attachmentID)
                                    .padding(.top, 8)
                                }//스크롤 바 숨김
                                
                                //제목
                                Text(memo.title)
                                    .id(titleID)//스크롤 고정시키기 위해 id부여
                                    .font(.largeTitle.bold())
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .padding(.top, 8)
                                
                                //본문
                                Text(memo.content)
                                    .multilineTextAlignment(currentAlignment)//문단 정렬
                                    .font(.system(textStyle))
                                    .bold(isBold)
                                    .italic(isItalic)
                                    .underline(isUnderlined)
                                    .strikethrough(isStrikeThrough)
                                    .foregroundStyle(selectedColor)
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                                //본문 일부의 서식까지 변경할 수 있도록 변경하려고 계획했는데, UIKit을 사용해야 해서 뒤로 밀려남
                                
                                
                                
                                Spacer().frame(height: 640)
                                //스크롤을 고정시키기 위해 페이지 크기를 늘림
                                
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical)
                            
                        }
                        .onAppear {
                            DispatchQueue.main.async {
                                proxy.scrollTo(memo.attachments.isEmpty ? titleID : attachmentID, anchor: .top)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation {
                                        isDateVisible = true
                                    }
                                }
                            }
                        }
                    }
                    
                }
                
                //하단 툴바(편집 시에만 표시)
                if isEditing {
                    HStack{
                        //텍스트 포맷 버튼
                        Button(action: handleFormatButton) {
                            Image(systemName: "textformat")
                                .font(.title2)
                                .foregroundStyle(.blue)
                        }
                        
                        Spacer()
                        
                        //이미지 파일 버튼
                        Button(action: { showingAttachmentOptions = true }) {
                            Image(systemName: "paperclip")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        .popover(isPresented: $showingAttachmentOptions) {
                            VStack(alignment: .leading) {
                                PhotosPicker(
                                    selection: $selectedPhotoItems,
                                    matching: .images
                                ) {
                                    HStack {
                                        Text("Select Image")
                                        Spacer()
                                        Image(systemName: "photo.on.rectangle")
                                    }
                                    .font(.system(size: 17, weight: .light))
                                    .foregroundColor(.black)
                                }
                                .onChange(of: selectedPhotoItems) {
                                    //selectedPhotoItems값이 바뀌면 팝오버 닫히도록
                                    showingAttachmentOptions = false
                                }
                                Divider()
                                Button{
                                    //파일 첨부_아직 기능 구현X
                                    showingAttachmentOptions = false
                                } label: {
                                    HStack {
                                        Text("Attach file")
                                        Spacer()
                                        Image(systemName: "doc")
                                    }
                                    .font(.system(size: 17, weight: .light))
                                    .foregroundColor(.secondary)
                                    
                                }
                                Divider()
                                Button {
                                    //오디오 첨부_아직 기능 구현X
                                    showingAttachmentOptions = false
                                } label: {
                                    HStack {
                                        Text("Record Audio")
                                        Spacer()
                                        Image(systemName: "waveform")
                                    }
                                    .font(.system(size: 17, weight: .light))
                                    .foregroundColor(.secondary)
                                }
                                
                            }
                            .padding(.horizontal)
                            .presentationCompactAdaptation(.popover)//뷰의 표시 방식을 팝오버로 강제하는 뷰 모디파이어
                            .frame(width: 240, height: 120)
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
                                //왼쪽 정렬
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
                                //가운데 정렬
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
                                //오른쪽 정렬
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
                    .padding(.horizontal, 28)
                    .frame(height: 60)
                    .background(Color(showFormattingPanel ? .systemGray6 : .systemBackground))
                    .overlay(Divider(), alignment: .top)//뷰 위에 구분선을 그려줌
                    
                }
            }
            // 텍스트 포맷 패널
            .overlay(alignment: .bottom) {
                if showFormattingPanel {
                    TextFormattingPanel(
                        isBold: $isBold,
                        isItalic: $isItalic,
                        isUnderlined: $isUnderlined,
                        isStrikeThrough: $isStrikeThrough,
                        selectedColor: $selectedColor,
                        textStyle: $textStyle,
                        content: $memo.content,
                        onClose: { showFormattingPanel = false }
                    )
                    .transition(.move(edge: .bottom))//아래에서 위로 이동하도록
                    .ignoresSafeArea(.container, edges: .bottom)
                    .onDisappear { isEditorFocused = false }
                }
            }
            .navigationBarBackButtonHidden(isEditing)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isEditing {
                        Button("Done") {
                            memo.modifiedAt = Date()
                            showFormattingPanel = false
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
                        //삭제버튼
                        Button(role: .destructive, action: {
                            showingDeleteConfirm = true
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                        //공유버튼
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
                //삭제 확인버튼
                Button("Delete", role: .destructive) {
                    deleteMemo()
                }
                //삭제 취소버튼
                Button("Cancel", role: .cancel) {}
            }
            .sheet(isPresented: $showingDatePicker) {
                DatePicker(
                    "Select Date",
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
            .onChange(of: selectedPhotoItems) { _, newItems in
                    Task {
                        for item in newItems {
                            if let data = try? await item.loadTransferable(type: Data.self) {
                                saveImage(data: data)
                            }
                        }
                    selectedPhotoItems.removeAll()
                }
            }
    }
    
    //메모삭제 함수
    private func deleteMemo() {
        modelContext.delete(memo)
        dismiss()
    }
    
    //메모 공유 함수
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
    
    //텍스트 포맷 함수
    private func handleFormatButton() {
        if showFormattingPanel {
            withAnimation {
                showFormattingPanel = false
            }
        } else {
            isEditorFocused = false
            withAnimation {
                showFormattingPanel = true
            }
        }
    }
    
    //첨부파일_이미지 저장_SwiftData
    private func saveImage(data: Data) {
        let fileName = "Img_\(UUID().uuidString).jpg"
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName) else { return }
        do {
            try data.write(to: url)
            let newAttachment = Attachment(
                fileName: fileName,
                fileURL: url.path,
                type: "image"
            )
            memo.attachments.append(newAttachment)
        } catch {
            print("이미지 저장 실패: \(error)")
        }
    }
    
    //첨부파일_이미지 삭제_SwiftData
    private func deleteAttachment(_ attachment: Attachment) {
        let fileURL = URL(fileURLWithPath: attachment.fileURL)
        try? FileManager.default.removeItem(at: fileURL)
        
        if let index = memo.attachments.firstIndex(where: { $0.id == attachment.id }) {
            memo.attachments.remove(at: index)
        }
    }
    
    //정렬 함수
    private var alignmentIcon: String {
        switch memo.textAlignment {
        case 1: return "text.aligncenter"
        case 2: return "text.alignright"
        default: return "text.alignleft"
        }
    }
    
    //날짜 형식 변환 함수
    private var formattedCustomDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: memo.customDate ?? memo.modifiedAt)
    }
    
    
}

#Preview {
    let container = try! ModelContainer(for: Memo.self, configurations: .init(isStoredInMemoryOnly: true))
    
    let sampleMemo = Memo(
        title: "회의 안건",
        content: "1. 프로젝트 현황\n2. 다음 마일스톤",
        textAlignment: 0
    )
    
    NavigationStack {
        MemoDetailView(memo: sampleMemo)
    }
    .modelContainer(container)
}







