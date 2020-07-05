//
//  ViewController.swift
//  Inside Skoop
//
//  Created by Abhi Velaga on 7/4/20.
//  Copyright © 2020 Abhi Velaga. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

var authenticated = false

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let departments = ["All Departments", "A", "B", "C", "D", "E"]
    
    @IBOutlet weak var departmentField: UITextField!
    @IBOutlet weak var searchField: UITextField!
    
    let thePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.layer.cornerRadius = 18.0
        searchField.layer.borderWidth = 1.0
        searchField.layer.borderColor = UIColor.lightGray.cgColor
        
        departmentField.layer.cornerRadius = 18.0
        departmentField.layer.borderWidth = 1.0
        departmentField.text  = departments[0]
        departmentField.layer.borderColor = UIColor.white.cgColor
        
        
        thePicker.delegate = self
        departmentField.inputView = thePicker
        
//        let ref = Database.database().reference(withPath: "courses")
//        print(ref)
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            
        }
        task.resume()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return departments.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return departments[row]
        
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        departmentField.text = departments[row]
    }
    
    // code to enable tapping on the background to remove software keyboard
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

