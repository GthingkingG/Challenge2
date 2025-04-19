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
    @Binding var isStrikeThrough: Bool
    @Binding var selectedColor: Color
    @Binding var textStyle: Font.TextStyle
    @Binding var content: String
    
    private let colors: [Color] = [
        .primary, .purple, .pink, .orange, .mint, .blue
    ]
    
    private let styles: [Font.TextStyle] = [
        .title, .title2, .title3, .body, .subheadline, .footnote
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                ForEach(styles, id: \.self) { style in
                    Button(action: { textStyle = style }) {
                        Text(style.label)
                            .font(.system(style))
                            .foregroundStyle(textStyle == style ? .blue : .primary)
                    }
                }
            }
            
            HStack(spacing: 20) {
                formatButton(systemName: "bold" , isActive: isBold) {
                    isBold.toggle()
                }
                formatButton(systemName: "italic" , isActive: isItalic) {
                    isItalic.toggle()
                }
                formatButton(systemName: "underline" , isActive: isUnderlined) {
                    isUnderlined.toggle()
                }
                formatButton(systemName: "strikethrough" , isActive: isStrikeThrough) {
                    isStrikeThrough.toggle()
                }
            }
            
            HStack(spacing: 20) {
                ForEach(colors, id: \.self) { color in
                    Button(action: { selectedColor = color }) {
                        Circle()
                            .fill(color)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(Color.blue, lineWidth: selectedColor == color ? 2 : 0)
                            )
                    }
                }
            }
            
            HStack(spacing: 20) {
                listStyleButton(symbol: "list.bullet", action: {
                    applyListStyle(symbol: "• ")
                })
                
                listStyleButton(symbol: "list.number", action: {
                    applyListStyle(symbol: "1. ")
                })
                
                listStyleButton(symbol: "list.dash", action: {
                    applyListStyle(symbol: "- ")
                })
            }
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
        .padding(.horizontal)
        .padding(.bottom, 40)
    }
    
    private func formatButton(
        systemName: String,
        isActive: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title2)
                .foregroundColor(isActive ? .blue : .primary)
                .frame(width: 44, height: 44)
                .background(isActive ? Color.blue.opacity(0.1) : Color.clear)
                .cornerRadius(8)
        }
    }
    
    private func listStyleButton(
        symbol: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.title2)
                .foregroundColor(.primary)
                .frame(width: 44, height: 44)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
    
    private func applyListStyle(symbol: String) {
        let lines = content.components(separatedBy: "\n")
        let formattedLines = lines.map { line in
            line.hasPrefix(symbol) ? String(line.dropFirst(symbol.count)) : symbol + line
        }
        content = formattedLines.joined(separator: "\n")
    }
}

extension Font.TextStyle {
    var label: String {
        switch self {
        case.title: return "Title"
        case.title2: return "Title 2"
        case.title3: return "Title 3"
        case.body: return "Body"
        case.subheadline: return "Subheadline"
        case.footnote: return "Footnote"
            default : return ""
        }
    }
}
