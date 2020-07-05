//
//  SettingsViewController.swift
//  Inside Skoop
//
//  Created by Abhi Velaga on 7/4/20.
//  Copyright © 2020 Abhi Velaga. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleUI()
    }
    
    func styleUI(){
        emailField.layer.cornerRadius = 18.0
        emailField.layer.borderWidth = 1.0
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        
        passwordField.layer.cornerRadius = 18.0
        passwordField.layer.borderWidth = 1.0
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        
        signUpButton.layer.cornerRadius = 18.0
        
        loginButton.layer.cornerRadius = 18.0
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    //    https://console.firebase.google.com/u/0/project/inside-skoop/authentication/users
    @IBAction func signUpPressed(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().createUser( withEmail: email, password: password) {
                user, error in if error == nil {
                    Auth.auth().signIn(
                        withEmail: email,
                        password: password
                    )
                    authenticated = true
                    self.dismiss(animated: true, completion: nil)
                }else{
                    switch error {
                    // wrong password
                    case .some(let error as NSError) where error.code == AuthErrorCode.wrongPassword.rawValue:
                        let controller = UIAlertController(
                            title: "Login Error",
                            message: "Wrong password",
                            preferredStyle: .alert)
                        controller.addAction(UIAlertAction(title:"Okay",style:.default,handler:nil))
                        self.present(controller, animated: true, completion: nil)
                    // alert with firebase error
                    case .some(let error):
                        let controller = UIAlertController(
                            title: "Login Error",
                            message: error.localizedDescription,
                            preferredStyle: .alert)
                        controller.addAction(UIAlertAction(title:"Okay",style:.default,handler:nil))
                        self.present(controller, animated: true, completion: nil)
                    case .none:
                        print("good")
                    }
                }
            }
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(
                withEmail: email,
                password: password
            ) { user, error in if error != nil {
                let controller = UIAlertController(
                    title: "Login Error",
                    message: "Wrong password",
                    preferredStyle: .alert)
                controller.addAction(UIAlertAction(title:"Okay",style:.default,handler:nil))
                self.present(controller, animated: true, completion: nil)
            } else{
                authenticated = true
                self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //    }
}
