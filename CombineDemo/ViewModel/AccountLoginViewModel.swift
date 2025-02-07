//
//  AccountLoginViewModel.swift
//  CombineDemo
//
//  Created by Huei-Der Huang on 2025/2/7.
//

import Foundation
import Combine

class AccountLoginViewModel {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    var isUsernameLessThan4Characters: AnyPublisher<Bool, Never> {
        $username.map { $0.count < 4 }.eraseToAnyPublisher()
    }
    
    var isPasswordLessThan8Characters: AnyPublisher<Bool, Never> {
        $password.map { $0.count < 8 }.eraseToAnyPublisher()
    }
    
    var isPasswordMatched: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $confirmPassword)
            .map { (password, confirmPassword) in
                password.count >= 8 && password == confirmPassword
            }.eraseToAnyPublisher()
    }
    
    var messagePublisher: AnyPublisher<String?, Never> {
        Publishers.CombineLatest3(isUsernameLessThan4Characters, isPasswordLessThan8Characters, isPasswordMatched)
            .map { (isUsernameLessThan4Characters, isPasswordLessThan8Characters, isPasswordMatched) in
                var message = ""
                if isUsernameLessThan4Characters {
                    message += UIStringModel.UsernameLessThan4Characters
                    message += "\n"
                }
                if isPasswordLessThan8Characters {
                    message += UIStringModel.PasswordLessThan8Characters
                    message += "\n"
                }
                if !isPasswordMatched {
                    message += UIStringModel.PasswordNoMatched
                }
                return message
            }.eraseToAnyPublisher()
    }
    
    var isLoginEnable: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isUsernameLessThan4Characters, isPasswordLessThan8Characters, isPasswordMatched)
            .map { (isUsernameLessThan4Characters, isPasswordLessThan8Characters, isPasswordMatched) in
                !isUsernameLessThan4Characters && !isPasswordLessThan8Characters && isPasswordMatched
            }.eraseToAnyPublisher()
    }
}
