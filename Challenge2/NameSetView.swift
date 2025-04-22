//
//  NameSetView.swift
//  Challenge2
//
//  Created by Air on 4/21/25.
//

import SwiftUI

struct NameSetView: View {
    let selectedType: myType
    @EnvironmentObject var userData: UserData
    @State var name: String = ""
    
   
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: MainView(selectedType: selectedType)) {
                    Text("Done")
                }
                
                
                ZStack {
                    Circle()
                        .fill(selectedType.typeColor)
                        .opacity(0.5)
                        .frame(width: 240, height: 240)
                    Text(name)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: 200)
                }
                .padding(.horizontal, 32)
                
                
                HStack {
                    TextField("Name", text: $name)
                        .font(.title3.bold())
                        .padding(.horizontal, 36)
                }
                .background(
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 320, height: 44)
                        .cornerRadius(16)
                )
                .padding()
            }
        }
        .navigationTitle("NameSet")
        .onDisappear() {
            userData.userName = name
            userData.userType = selectedType
            UserDefaults.standard.set(true, forKey: "ss")
        }
        
    }
}

#Preview {
    NameSetView(selectedType: .greenOnions)
        .environmentObject(UserData())
}
