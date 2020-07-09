//
//  SettingsViewController.swift
//  Inside Skoop
//
//  Created by Abhi Velaga on 7/4/20.
//  Copyright © 2020 Abhi Velaga. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreData

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var darkModeButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var delegate: PopoverGiver!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if authenticated {
            titleField.isHidden = true
            emailField.isHidden = true
            passwordField.isHidden = true
            signUpButton.isHidden = true
            loginButton.isHidden = true
            logoutButton.isHidden = false
        }else{
            titleField.isHidden = false
            emailField.isHidden = false
            passwordField.isHidden = false
            signUpButton.isHidden = false
            loginButton.isHidden = false
            logoutButton.isHidden = true
        }
        
        if(darkMode){
            overrideUserInterfaceStyle = .dark
            darkModeButton.tintColor = .white
        }else{
            overrideUserInterfaceStyle = .light
            darkModeButton.tintColor = .black
        }
    }
    
    func styleUI(){
        emailField.layer.cornerRadius = 18.0
        emailField.layer.borderWidth = 1.0
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        
        passwordField.layer.cornerRadius = 18.0
        passwordField.layer.borderWidth = 1.0
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        
        signUpButton.layer.cornerRadius = 18.0
        logoutButton.layer.cornerRadius = 18.0
        
        loginButton.layer.cornerRadius = 18.0
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func saveLogin(email: String, password: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let login = NSEntityDescription.entity(forEntityName: "Login", in: context)
        let newUser = NSManagedObject(entity: login!, insertInto: context)
        newUser.setValue(email, forKey: "email")
        newUser.setValue(password, forKey: "password")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func deleteLogin() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                context.delete(data)
            }
            
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
            
        } catch {
            
            print("Failed")
        }
        
    }
    
    func deleteDarkmode(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DarkMode")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                context.delete(data)
            }
            
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    func setDarkmode() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let dm = NSEntityDescription.entity(forEntityName: "DarkMode", in: context)
        let newSetting = NSManagedObject(entity: dm!, insertInto: context)
        newSetting.setValue(darkMode, forKey: "on")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().createUser( withEmail: email, password: password) {
                user, error in if error == nil {
                    Auth.auth().signIn(
                        withEmail: email,
                        password: password
                    )
                    authenticated = true
                    self.saveLogin(email: email, password: password)
                    self.delegate.refresh()
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
                self.saveLogin(email: email, password: password)
                self.delegate.refresh()
                self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func logoutPressed(_ sender: Any) {
        deleteLogin()
        authenticated = false
        delegate.refresh()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func darkModeToggled(_ sender: Any) {
        
        darkMode = !darkMode
        if(darkMode){
            overrideUserInterfaceStyle = .dark
            darkModeButton.tintColor = .white
        }else{
            overrideUserInterfaceStyle = .light
            darkModeButton.tintColor = .black
        }
        
        deleteDarkmode() // remove object
        setDarkmode() // save new toggled version
        delegate.refresh()
    }
}
