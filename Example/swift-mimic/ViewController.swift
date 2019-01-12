//
//  ViewController.swift
//  swift-mimic
//
//  Created by goktugberkulu on 12/24/2018.
//  Copyright (c) 2018 goktugberkulu. All rights reserved.
//

import UIKit
import Alamofire
import swift_mimic

private let BaseAPIURL = "https://api.github.com"


class APIManager {
    var sessionManager: SessionManager
    
    init() {
        if let mockUrlSessionConfiguration = MimicSession.shared?.urlSessionConfiguration {
            sessionManager = Alamofire.SessionManager(configuration: mockUrlSessionConfiguration)
        } else {
            sessionManager =  SessionManager.default
        }
    }
}


class ViewController: UIViewController {
    
    let apiManager = APIManager()
    
    var usernameField: UITextField?
    var passwordField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usernameField = UITextField(frame: .zero)
        
        usernameField.placeholder = "Username"
        usernameField.autocapitalizationType = .none
        usernameField.autocorrectionType = .no
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.returnKeyType = .next
        usernameField.borderStyle = .roundedRect
        usernameField.accessibilityIdentifier = "username"
        usernameField.delegate = self
        
        view.addSubview(usernameField)
        
        usernameField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        usernameField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        usernameField.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100.0).isActive = true
        usernameField.heightAnchor.constraint(equalToConstant: 44.0).isActive = true

        let passwordField = UITextField(frame: .zero)
        
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.returnKeyType = .go
        passwordField.borderStyle = .roundedRect
        passwordField.accessibilityIdentifier = "password"
        passwordField.delegate = self

        view.addSubview(passwordField)
        
        passwordField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        passwordField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        passwordField.topAnchor.constraint(equalTo: usernameField.layoutMarginsGuide.bottomAnchor, constant: 40.0).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        self.usernameField = usernameField
        self.passwordField = passwordField
    }
    
    func authenticateAndFetchRepos() -> Void {
        guard let username = usernameField?.text,
            let password = usernameField?.text else {
                return
        }
        
        apiManager.sessionManager.request(
            BaseAPIURL,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding(),
            headers: nil
        ).authenticate(
            user: username,
            password: password
        ).response { (defaultDataResponse) in
            
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !textField.hasText {
            return false
        }
        
        if textField == self.usernameField {
            self.passwordField?.becomeFirstResponder()
            return true
        }
        
        self.authenticateAndFetchRepos()
        
        return true
    }
    
}
