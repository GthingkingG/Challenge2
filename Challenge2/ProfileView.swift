//
//  ProfileView.swift
//  Challenge2
//
//  Created by Air on 4/21/25.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var UserData: UserData
    
    let selectedType: myType
    
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
            
            Text(UserData.userName)
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
                .background(
                    Circle()
                        .fill(selectedType.typeColor)
                        .opacity(0.3)
                        .frame(width: 100, height: 100)
                        .shadow(radius: 8)
                        
                )
            
            Spacer()
            VStack {
                ZStack{
                    Circle()
                        .fill(selectedType.typeColor.opacity(0.7))
                        .frame(width: 80, height: 80)

                    Image("\(selectedType.rawValue)")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .scaledToFill()
                }
                .padding(.top, 18)
                .padding(.bottom, 6)
                
                Text(selectedType.rawValue)
                    .font(.subheadline.bold())
                    .foregroundStyle(.black)
                    .padding(.bottom, 16)
                    .lineLimit(1)
                
            }
            .frame(maxWidth: 200, maxHeight: 140)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.15))
            }
            ZStack {
                Rectangle()
                    .fill(.white)
                    .frame(width: 370, height: 252)
                    .cornerRadius(16)
                VStack(alignment: .leading) {
                    Text("의미: \(selectedType.typeMeans)")
                        .padding(.leading, 4)
                    Spacer().frame(height: 44)
                    Text("설명: \(selectedType.typeDetail)")
                        .frame(width: 320)
                }
                .font(.title2)
                
            }
            
                
                
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .background(Color(.systemGray6))
    }
}

#Preview {
    ProfileView(selectedType: .basil)
        .environmentObject(UserData())
    
}
