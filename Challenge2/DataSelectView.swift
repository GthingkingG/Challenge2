//
//  DataSelect.swift
//  Challenge2
//
//  Created by Air on 4/21/25.
//

import SwiftUI



struct DataSelectView: View {
    @EnvironmentObject var userData: UserData
    
    
    var body: some View {
        
        NavigationStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12, content: {
                ForEach(myType.allCases, id: \.self) { data in
                    NavigationLink(destination: NameSetView(selectedType: data, userData: .init())) {
                        contentsCard(data: data)
                    }
                }
            })
            .safeAreaPadding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    func contentsCard(data: myType) -> some View {
            VStack {
                ZStack{
                    Circle()
                        .fill(data.typeColor.opacity(0.7))
                        .frame(width: 80, height: 80)

                    Image("\(data.rawValue)")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .scaledToFill()
                }
                .padding(.top, 18)
                .padding(.bottom, 6)
                
                Text(data.typeName)
                    .font(.subheadline.bold())
                    .foregroundStyle(.black)
                    .padding(.bottom, 16)
                    .lineLimit(1)
                
            }
            .frame(maxWidth: .infinity, maxHeight: 148)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.15))
            }

    }
}

#Preview {
    DataSelectView()
        .environmentObject(UserData())
}
