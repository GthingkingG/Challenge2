//
//  NameSetView.swift
//  Challenge2
//
//  Created by Air on 4/21/25.
//

import SwiftUI
import SwiftData

struct NameSetView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var name: String = ""
    var selectedType: myType
   
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: MainView()) {
                    Text("Done")
                }
                .offset(x: 140 ,y: 40)
                .padding()
                
                
                Spacer().frame(height: 140)
                
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
                .padding(24)
                
                
                
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
                Spacer()
            }
        }
        .navigationTitle("NameSet")
        .onDisappear() {
            saveInfo()
            UserDefaults.standard.set(true, forKey: "isDataSelected")
            
        }
        
    }
    
    private func saveInfo() {
        let newUser = UserInfo(userName: name, userType: selectedType, memos: [])
            modelContext.insert(newUser)
        do {
            try modelContext.save()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    NameSetView(selectedType: .basil)
}
