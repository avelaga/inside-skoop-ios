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
    
    // saved search parameters
    var query = ""
    var department = "All Departments"
    var easyA = false
    var goodProfessor = false
    var lightHomework = false
    var projectHeavy = false
    var actuallyUseful = false
    
    @IBOutlet weak var departmentField: UITextField!
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var easyAButton: UIButton!
    @IBOutlet weak var goodProfessorButton: UIButton!
    @IBOutlet weak var lightHomeworkButton: UIButton!
    @IBOutlet weak var projectHeavyButton: UIButton!
    @IBOutlet weak var actuallyUsefulButton: UIButton!
    
    @IBOutlet weak var searchButton: UIButton!
    
    let thePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thePicker.delegate = self
        departmentField.inputView = thePicker
        initUIStyles()
        //        let ref = Database.database().reference(withPath: "courses")
        
        //        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")
        //        guard let requestUrl = url else { fatalError() }
        //        var request = URLRequest(url: requestUrl)
        //        request.httpMethod = "GET"
        //        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        //
        //            // Check if Error took place
        //            if let error = error {
        //                print("Error took place \(error)")
        //                return
        //            }
        //
        //            // Read HTTP Response Status code
        //            if let response = response as? HTTPURLResponse {
        //                print("Response HTTP Status code: \(response.statusCode)")
        //            }
        //
        //            // Convert HTTP Response Data to a simple String
        //            if let data = data, let dataString = String(data: data, encoding: .utf8) {
        //                print("Response data string:\n \(dataString)")
        //            }
        //
        //        }
        //        task.resume()
    }
    
    func initUIStyles(){
//        let buttonRadius = 15.0
        searchField.layer.cornerRadius = 18.0
        searchField.layer.borderWidth = 1.0
        searchField.layer.borderColor = UIColor.lightGray.cgColor
        
        departmentField.layer.cornerRadius = 18.0
        departmentField.layer.borderWidth = 1.0
        departmentField.text  = departments[0]
        departmentField.layer.borderColor = UIColor.white.cgColor
        
        easyAButton.layer.cornerRadius = 18.0
        goodProfessorButton.layer.cornerRadius = 18.0
        lightHomeworkButton.layer.cornerRadius = 18.0
        projectHeavyButton.layer.cornerRadius = 18.0
        actuallyUsefulButton.layer.cornerRadius = 18.0
        
        easyAButton.layer.borderWidth = 1.0
        goodProfessorButton.layer.borderWidth = 1.0
        lightHomeworkButton.layer.borderWidth = 1.0
        projectHeavyButton.layer.borderWidth = 1.0
        actuallyUsefulButton.layer.borderWidth = 1.0
        
        setButtonAsUnselected(button: easyAButton)
        setButtonAsUnselected(button: goodProfessorButton)
        setButtonAsUnselected(button: lightHomeworkButton)
        setButtonAsUnselected(button: projectHeavyButton)
        setButtonAsUnselected(button: actuallyUsefulButton)
        
        searchButton.layer.borderColor = UIColor.lightGray.cgColor
        searchButton.layer.cornerRadius = 23.0
        searchButton.layer.borderWidth = 1.0
    }
    
    func setButtonAsSelected(button: UIButton){
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = UIColor(red: 237/255, green: 125/255, blue: 121/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
    }
    
    func setButtonAsUnselected(button: UIButton){
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    @IBAction func easyAToggled(_ sender: Any) {
        if easyA {
            setButtonAsUnselected(button: easyAButton)
        }else{
            setButtonAsSelected(button: easyAButton)
        }
        easyA = !easyA
    }
    
    @IBAction func goodProfessorToggled(_ sender: Any) {
        if goodProfessor {
            setButtonAsUnselected(button: goodProfessorButton)
        }else{
            setButtonAsSelected(button: goodProfessorButton)
        }
        goodProfessor = !goodProfessor
    }
    
    @IBAction func lightHomeworkToggle(_ sender: Any) {
        if lightHomework {
            setButtonAsUnselected(button: lightHomeworkButton)
        }else{
            setButtonAsSelected(button: lightHomeworkButton)
        }
        lightHomework = !lightHomework
    }
    
    @IBAction func projectHeavyToggled(_ sender: Any) {
        if projectHeavy {
            setButtonAsUnselected(button: projectHeavyButton)
        }else{
            setButtonAsSelected(button: projectHeavyButton)
        }
        projectHeavy = !projectHeavy
    }
    
    @IBAction func actuallyUsefulToggled(_ sender: Any) {
        if actuallyUseful {
            setButtonAsUnselected(button: actuallyUsefulButton)
        }else{
            setButtonAsSelected(button: actuallyUsefulButton)
        }
        actuallyUseful = !actuallyUseful
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        performSegue(withIdentifier: "SearchSegueID", sender: nil)
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
        department = departments[row]
        departmentField.text = department
    }
    
    // code to enable tapping on the background to remove software keyboard
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // make api call for search here with stored parameters and store result in destination
    }
    
}

