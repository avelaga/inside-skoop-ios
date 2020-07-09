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
import CoreData

let defaults = UserDefaults.standard
var authenticated = false
var darkMode = false

//let rootUrl = "http://abhivelaga.com:8000" // public facing url !!!!!! Dr.Bulko - make sure this is uncommented and the line after is commented !!!!!
let rootUrl = "http://192.168.1.170:8000" // private url

struct Department: Decodable {
    let id: Int
    let name: String
}

protocol PopoverGiver {
    func refresh()
}

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, PopoverGiver {
    
    
    var departments: [String] = ["All Departments"]
    
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
    
    @IBOutlet weak var writeAReviewButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
    let thePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thePicker.delegate = self
        departmentField.inputView = thePicker
        initUIStyles()
        autoLogin()
        getDepartments()
        darkMode = retreiveDarkmode()
    }
    
    // get list of available departments from backend
    func getDepartments(){
        departments.removeAll()
        departments.append("All Departments")
        let url = URL(string: "\(rootUrl)/departments")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                
                let jsondata = dataString.data(using: .utf8)!
                let dep: [Department] = try! JSONDecoder().decode([Department].self, from: jsondata)
                DispatchQueue.main.async {
                    for index in 0..<dep.count {
                        self.departments.append(dep[index].name)
                    }
                }
            }
        }
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(darkMode){
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
    }
    
    func refresh() {
        if(darkMode){
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
    }
    
    // if login credentials are stored on device, login on launch
    func autoLogin(){
        let creds:(email: String, password: String) = retreiveLogin()
        if creds.email != "error" {
            Auth.auth().signIn(
                withEmail: creds.email,
                password: creds.password
            )
            authenticated = true
        }
    }
    
    func retreiveLogin() -> (email: String, password: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let email = data.value(forKey: "email") as! String
                let password = data.value(forKey: "password") as! String
                print(email)
                print(password)
                return (email: email, password: password)
            }
            
        } catch {
            
            print("Failed")
        }
        return (email: "error", password: "error")
    }
    
    func retreiveDarkmode() -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DarkMode")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let on = data.value(forKey: "on") as! Bool
                return on
            }
            
        } catch {
            
            print("Failed")
        }
        return false
    }
    
    // these have to be programatically defined
    func initUIStyles(){
        searchField.layer.cornerRadius = 18.0
        searchField.layer.borderWidth = 1.0
        searchField.layer.borderColor = UIColor.lightGray.cgColor
        
        departmentField.layer.cornerRadius = 18.0
        departmentField.layer.borderWidth = 0
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
        button.setTitleColor(.label, for: .normal)
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
        if segue.identifier == "SearchSegueID" {
            // send search parameters to list view vc
            let destination = segue.destination as! ListViewController
            destination.query = searchField.text!
            destination.department = departmentField.text!
            destination.easyA = easyA
            destination.goodProfessor = goodProfessor
            destination.lightHomework = lightHomework
            destination.projectHeavy = projectHeavy
            destination.actuallyUseful = actuallyUseful
        }
        else if segue.identifier == "SettingsSegueID" {
            let destination = segue.destination as! SettingsViewController
            destination.delegate = self
        }
    }
}
