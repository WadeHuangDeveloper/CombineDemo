//
//  LoginViewController.swift
//  CombineDemo
//
//  Created by Huei-Der Huang on 2024/5/13.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    private var viewModel = LoginViewModel()
    private var subscritions = Set<AnyCancellable>()

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCombine()
    }

    private func setupUI() {
        usernameTextField.text = ""
        usernameTextField.delegate = self
        passwordTextField.text = ""
        passwordTextField.delegate = self
        repeatPasswordTextField.text = ""
        repeatPasswordTextField.delegate = self
        loginButton.isEnabled = false
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }

    private func setupCombine() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: usernameTextField)
            .compactMap({ ($0.object as? UITextField)?.text }) // Filter nil
            .assign(to: \.username, on: viewModel) // Assign text from publisher to viewModel
            .store(in: &subscritions) // Store subscription
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: passwordTextField)
            .compactMap({ ($0.object as? UITextField)?.text }) // Filter nil
            .assign(to: \.password, on: viewModel) // Assign text from publisher to viewModel
            .store(in: &subscritions) // Store subscription
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: repeatPasswordTextField)
            .compactMap({ ($0.object as? UITextField)?.text }) // Filter nil
            .assign(to: \.repeatPassword, on: viewModel) // Assign text from publisher to viewModel
            .store(in: &subscritions) // Store subscription
        
        viewModel.isAllowToLogin
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &subscritions)
    }
    
    @objc private func didTapLogin() {
        showAlert()
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Login", message: "Succeeded", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true) { [weak self] in
            self?.view.endEditing(true)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
