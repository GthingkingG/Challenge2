//
//  ProfileView.swift
//  Challenge2
//
//  Created by Air on 4/21/25.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .padding(.horizontal, 16)
                    }
                    
                }
                Text("Profile")
                    .font(.largeTitle.bold())
                    .padding(16)
            }
            .background(.white)
            
            Spacer()
            
            Text("One")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
                .background(
                    Circle()
                        .fill(Color.blue)
                        .opacity(0.3)
                        .frame(width: 100, height: 100)
                        .shadow(radius: 8)
                        
                )
            
            Spacer()
            
            Rectangle()
                .fill(.blue)
                .frame(width: 370, height: 252)
                .cornerRadius(16)
                
                
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .background(Color(.systemGray6))
    }
}

#Preview {
    ProfileView()
}
