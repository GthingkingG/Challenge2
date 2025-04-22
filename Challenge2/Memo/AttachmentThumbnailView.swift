//
//  AttachmentThumbnailView.swift
//  Challenge2
//
//  Created by Air on 4/18/25.
//

import SwiftUI

struct AttachmentThumbnailView: View {
    let attachment: Attachment
    let isEditing: Bool
    let onDelete: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if attachment.type == "image",
               let uiImage = UIImage(contentsOfFile: attachment.fileURL) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 240, height: 240)
                    .clipped()
                    .cornerRadius(8)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 200, height: 200)
                    .overlay(
                        Image(systemName: "questionmark")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    )
            }
            if isEditing {
                //첨부파일_이미지 삭제 버튼
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .background(Color.white.opacity(0.7).clipShape(Circle()))
                }
                .offset(x: 8, y: -8)
            }
        }
    }
}
