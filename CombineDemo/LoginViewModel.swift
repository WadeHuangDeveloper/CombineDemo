//
//  LoginViewModel.swift
//  CombineDemo
//
//  Created by Huei-Der Huang on 2024/5/13.
//

import Foundation
import Combine

class LoginViewModel {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var repeatPassword: String = ""
    
    // Check that password is equal to repeat password
    var isPasswordValid: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest($password, $repeatPassword)
            .map({ password, repeatPassword in
                return password != "" && repeatPassword != "" && password == repeatPassword
            })
            .eraseToAnyPublisher()
    }
    
    // Check that username and passwords are valid
    var isAllowToLogin: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(isPasswordValid, $username)
            .map({ isPasswordValid, username in
                return isPasswordValid && !username.isEmpty
            })
            .eraseToAnyPublisher()
    }
}
