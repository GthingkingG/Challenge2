//
//  ProfileView.swift
//  Challenge2
//
//  Created by Air on 4/21/25.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var userInfos: [UserInfo]
    
    @Environment(\.dismiss) private var dismiss
    
    @State var isCard: Bool = false
    
    var body: some View {
        let userInfo: UserInfo = userInfos.first ?? UserInfo.init(userName: "Name", userType: .greenOnions)
        
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
            
            ZStack {
                Circle()
                    .fill(userInfo.userType.typeColor)
                    .opacity(0.5)
                    .frame(width: 160, height: 160)
                Text(userInfo.userName)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(width: 120)
            }
            .padding(.horizontal, 32)
            
            Spacer()
            Button {
                isCard.toggle()
            } label: {
                if isCard {
                    VStack {
                        ZStack{
                            Circle()
                                .fill(userInfo.userType.typeColor.opacity(0.7))
                                .frame(width: 160, height: 160)

                            Image("\(userInfo.userType.rawValue)")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .scaledToFill()
                        }
                        .padding(.top, 18)
                        .padding(.bottom, 6)
                        
                        Text(userInfo.userType.rawValue)
                            .font(.largeTitle.bold())
                            .foregroundStyle(.black)
                            .padding(.bottom, 16)
                            .lineLimit(1)
                        
                    }
                    .frame(width: 370, height: 252)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(userInfo.userType.typeColor.opacity(0.7))
                            .stroke(Color.white, lineWidth: 4)
                            
                    }
                    
                } else {
                    ZStack {
                        Rectangle()
                            .fill(.white)
                            .frame(width: 370, height: 252)
                            .cornerRadius(16)
                        VStack(alignment: .leading) {
                            Text("타입: \(userInfo.userType.typeName)")
                            Divider().frame(width: 320, height: 12)
                            Text("의미: \(userInfo.userType.typeMeans)")
                            Divider().frame(width: 320, height: 12)
                            Text("설명: \(userInfo.userType.typeDetail)")
                                .frame(width: 320)
                        }
                        .font(.title3)
                        .foregroundStyle(.black)
                        
                    }
                }
            }
            
            
                
                
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .background(Color(.systemGray6))
    }
}

#Preview {
    ProfileView()
    
}
