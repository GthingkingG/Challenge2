//
//  ProfileView.swift
//  Challenge2
//
//  Created by Air on 4/21/25.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userData: UserData
    
    @State var isCard: Bool = false
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
            
            ZStack {
                Circle()
                    .fill(selectedType.typeColor)
                    .opacity(0.5)
                    .frame(width: 160, height: 160)
                Text(userData.userName)
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
                                .fill(selectedType.typeColor.opacity(0.7))
                                .frame(width: 160, height: 160)

                            Image("\(selectedType.rawValue)")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .scaledToFill()
                        }
                        .padding(.top, 18)
                        .padding(.bottom, 6)
                        
                        Text(selectedType.rawValue)
                            .font(.largeTitle.bold())
                            .foregroundStyle(.black)
                            .padding(.bottom, 16)
                            .lineLimit(1)
                        
                    }
                    .frame(width: 370, height: 252)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(selectedType.typeColor.opacity(0.7))
                            .stroke(Color.white, lineWidth: 4)
                            
                    }
                    
                } else {
                    ZStack {
                        Rectangle()
                            .fill(.white)
                            .frame(width: 370, height: 252)
                            .cornerRadius(16)
                        VStack(alignment: .leading) {
                            Text("타입: \(selectedType.typeName)")
                            Divider().frame(width: 320, height: 12)
                            Text("의미: \(selectedType.typeMeans)")
                            Divider().frame(width: 320, height: 12)
                            Text("설명: \(selectedType.typeDetail)")
                                .frame(width: 320)
                        }
                        .font(.title2)
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
    ProfileView(selectedType: .basil)
        .environmentObject(UserData())
    
}
