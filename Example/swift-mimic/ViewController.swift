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


extension Data {
    internal func jsonObjectRepresentation() -> Any? {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: .mutableContainers)
            
            return json
        } catch {
            print("Something went wrong")
        }
        
        return nil
    }
}


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
    var resultField: UILabel?
    
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
        
        let loginButton = UIButton(type: .roundedRect)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.accessibilityIdentifier = "login_button"
        loginButton.addTarget(self,
                              action: #selector(didTap(loginButton:)),
                              for: .touchUpInside)
        
        view.addSubview(loginButton)
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordField.layoutMarginsGuide.bottomAnchor, constant: 40.0).isActive = true
        
        let resultField = UILabel(frame: .zero)
        
        resultField.lineBreakMode = .byWordWrapping
        resultField.numberOfLines = 0
        resultField.translatesAutoresizingMaskIntoConstraints = false
        resultField.accessibilityIdentifier = "results"
        resultField.backgroundColor = UIColor.lightGray
        
        view.addSubview(resultField)
        
        resultField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        resultField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        resultField.topAnchor.constraint(equalTo: loginButton.layoutMarginsGuide.bottomAnchor, constant: 80.0).isActive = true
        
        self.usernameField = usernameField
        self.passwordField = passwordField
        self.resultField = resultField
        
        usernameField.becomeFirstResponder()
    }
    
    @objc func didTap(loginButton: UIButton) {
        authenticateAndFetchRepos()
    }
    
    func authenticateAndFetchRepos() -> Void {
        guard let username = usernameField?.text, username.count > 0,
            let password = passwordField?.text, password.count > 0 else {
                return
        }
        
        self.resignFirstResponder()
        
        apiManager.sessionManager.request(
            BaseAPIURL + "/repos",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding(),
            headers: nil
        ).authenticate(
            user: username,
            password: password
        ).response { (defaultDataResponse) in
            if let error = defaultDataResponse.error {
                print("Error: " + error.localizedDescription)
                self.resultField?.text = "Error"
                return
            }
            
            guard let data = defaultDataResponse.data,
                let jsonData = data.jsonObjectRepresentation() as? NSDictionary else {
                    return
            }
            
            print("Response: " + jsonData.description)
            self.resultField?.text = "Success"
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
