//
//  UserData.swift
//  Challenge2
//
//  Created by Air on 4/21/25.
//

import Foundation

class UserData: ObservableObject {
    @Published var userName: String = ""
    @Published var userType: myType?  // 열거형 타입으로 변경
    @Published var isUserRegistered: Bool = false
    
    
    
    private let userDefaults = UserDefaults.standard
    private let userNameKey = "userName"
    private let userTypeKey = "userType"
    
    init() {
        loadUserData()
    }
    
    private func loadUserData() {
        if let name = userDefaults.string(forKey: userNameKey),
           let typeRawValue = userDefaults.string(forKey: userTypeKey),
           let type = myType(rawValue: typeRawValue) {
            userName = name
            userType = type
            isUserRegistered = true
        }
    }
    
    func saveUserData(name: String, type: myType) {
        userName = name
        userType = type
        userDefaults.set(name, forKey: userNameKey)
        userDefaults.set(type.rawValue, forKey: userTypeKey)
        isUserRegistered = true
    }
}

