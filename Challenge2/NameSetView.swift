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
                
                
                Text(name)
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 240, height: 240)
                    .background(
                        Circle()
                            .fill(selectedType.typeColor)
                            .opacity(0.3)
                    )
                    .padding()
                
                
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
//            userData.isUserRegistered = true
//            UserDefaults.standard.bool(forKey: "ss")
            UserDefaults.standard.set(true, forKey: "ss")
//            UserDefaults.setValue(true, forKey: "ss")
        }
        
    }
}

#Preview {
    NameSetView(selectedType: .greenOnions)
        .environmentObject(UserData())
}
