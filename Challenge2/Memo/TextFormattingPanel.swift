//
//  TextFormattingPanel.swift
//  Challenge2
//
//  Created by Air on 4/19/25.
//

import SwiftUI

struct TextFormattingPanel: View {
    @Binding var isBold: Bool
    @Binding var isItalic: Bool
    @Binding var isUnderlined: Bool
    @Binding var isStrikeThrough: Bool//중간줄
    @Binding var selectedColor: Color
    @Binding var textStyle: Font.TextStyle
    @Binding var content: String
    
    //텍스트 포맷 창 닫기
    var onClose: () -> Void
    
    //색 변수
    private let colors: [Color] = [.black, .purple, .pink, .orange, .mint, .blue]
    private let colorNames = ["Black", "Purple", "Pink", "Orange", "Mint", "Blue"]
    
    //글씨크기 변수
    private let styles: [(style: Font.TextStyle, name: String)] = [
        (.title, "Title"),
        (.title2, "Subtitle"),
        (.title3, "Subhead"),
        (.body, "Body")
    ]
    
    @State private var showingColorPicker = false
    
    var body: some View {
        VStack(spacing: 16) {
            //제목 + x버튼
            HStack {
                Text("Format")
                    .font(.headline)
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(Color(.systemGray4))
                    
                }
                
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 6)
            
            //글씨크기
            HStack {
                ForEach(styles.indices, id: \.self) { index in
                    let style = styles[index]
                    Button(action: { textStyle = style.style }) {
                        Text(style.name)
                            .font(.system(style.style))
                            .foregroundColor(textStyle == style.style ? .blue : .primary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 24)
            
            //글씨체
            HStack {
                HStack(spacing: 2) {
                    FormatButton(systemName: "bold", isActive: isBold) { isBold.toggle() }
                        .frame(width: 64, height: 44)
                    
                    Divider().frame(height: 24)
                    
                    FormatButton(systemName: "italic", isActive: isItalic) { isItalic.toggle() }
                        .frame(width: 64, height: 44)
                    
                    Divider().frame(height: 24)
                    
                    FormatButton(systemName: "underline", isActive: isUnderlined) { isUnderlined.toggle() }
                        .frame(width: 64, height: 44)
                    
                    Divider().frame(height: 24)
                    
                    FormatButton(systemName: "strikethrough", isActive: isStrikeThrough) { isStrikeThrough.toggle() }
                        .frame(width: 64, height: 44)
                }
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Spacer()
                
                //글씨 색
                HStack(spacing: 2) {
                    Button(action: { showingColorPicker.toggle() }) {
                        Image(systemName: "pencil")
                            .font(.title3)
                            .foregroundStyle(.black)
                    }
                    .frame(width: 44, height: 44)
                    .popover(isPresented: $showingColorPicker) {
                        VStack(spacing: 10) {
                            ForEach(colors.indices, id: \.self) { index in
                                Button(action: {
                                    selectedColor = colors[index]
                                    showingColorPicker = false
                                }) {
                                    HStack {
                                        Text(colorNames[index])
                                        Spacer()
                                        Circle()
                                            .fill(colors[index])
                                            .frame(width: 20, height: 20)
                                        
                                    }
                                    .padding(.horizontal)
                                    
                                }
                                Divider()
                            }
                            
                        }
                        .presentationCompactAdaptation(.popover)
                        .frame(width: 250, height: 260)
                    }
                    
                    Divider().frame(height: 24)
                    
                    Circle()
                        .fill(selectedColor)
                        .frame(width: 16, height: 16)
                        .frame(width: 44, height: 44)
                }
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(.horizontal, 28)
            
            
            //리스트 형식
            HStack {
                HStack {
                    //점 리스트
                    Button(action: { applyListStyle(symbol: "• ") }) {
                        Image(systemName: "list.bullet")
                    }
                    .frame(width: 52, height: 44)
                    
                    Divider().frame(height: 24)
                    
                    //숫자 리스트
                    Button(action: { applyListStyle(symbol: "1. ") }) {
                        Image(systemName: "list.number")
                    }
                    .frame(width: 52, height: 44)
                    
                    Divider().frame(height: 24)
                    
                    //대시 리스트
                    Button(action: { applyListStyle(symbol: "- ") }) {
                        Image(systemName: "list.dash")
                    }
                    .frame(width: 52, height: 44)
                }
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                
                Spacer()
                
                HStack {
                    //왼쪽 Tab(아직 구현 X)
                    Button(action: { applyIndent(increase: false) }) {
                        Image(systemName: "decrease.indent")
                            .foregroundStyle(Color.gray)
                    }
                    .frame(width: 52, height: 44)
                    
                    Divider().frame(height: 24)
                    
                    //오른쪽 Tab
                    Button(action: { applyIndent(increase: true) }) {
                        Image(systemName: "increase.indent")
                    }
                }
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Spacer()
                
                //인용구 추가
                Button(action: appplyQuote) {
                    Image(systemName: "text.quote")
                }
                .frame(width: 52, height: 44)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(FormatButtonStyle())
            .padding(.horizontal, 28)
            
            
            
        }
        .padding(.top, 20)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity)
        .background(
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)
        )
        .cornerRadius(16)
    }
    
    //리스트 적용 함수
    private func applyListStyle(symbol: String) {
        let lines = content.components(separatedBy: "\n")
        let newLines = lines.map { line in
            line.hasPrefix(symbol) ? String(line.dropFirst(symbol.count)) : symbol + line
        }
        content = newLines.joined(separator: "\n")
    }
    
    //간격 적용 함수
    private func applyIndent(increase: Bool) {
        let indent = increase ? "    " : ""
        let lines = content.components(separatedBy: "\n")
        let newLines = lines.map { indent + $0}
        content = newLines.joined(separator: "\n")
    }
    
    //인용구 적용 함수
    private func appplyQuote() {
        let lines = content.components(separatedBy: "\n")
        let newLines = lines.map { "> " + $0 }
        content = newLines.joined(separator: "\n")
    }
}

//버튼 스타일 재사용
struct FormatButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20))
            .frame(width: 44, height: 44)
            .background(configuration.isPressed ? Color.blue.opacity(0.1) : Color.clear)
            .cornerRadius(8)
    }
}

struct FormatButton: View {
    let systemName: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 20))
                .frame(width: 44, height: 44)
                .foregroundColor(isActive ? .blue : .primary)
                .cornerRadius(8)
        }
    }
}


#Preview {
    struct PreviewContainer: View {
        @State private var isBold = false
        @State private var isItalic = false
        @State private var isUnderlined = false
        @State private var isStrikeThrough = false
        @State private var selectedColor: Color = .primary
        @State private var textStyle: Font.TextStyle = .body
        @State private var content: String = "Sample text content"
        
        var body: some View {
            ZStack(alignment: .bottom) {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                TextFormattingPanel(
                    isBold: $isBold,
                    isItalic: $isItalic,
                    isUnderlined: $isUnderlined,
                    isStrikeThrough: $isStrikeThrough,
                    selectedColor: $selectedColor,
                    textStyle: $textStyle,
                    content: $content,
                    onClose: {}
                )
            }
        }
    }
    return PreviewContainer()
}
