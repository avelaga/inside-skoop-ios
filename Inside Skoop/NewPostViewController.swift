//
//  NewPostViewController.swift
//  Inside Skoop
//  EID: ASV583
//  Course: CS371L
//
//  Created by Abhi Velaga on 7/5/20.
//  Copyright © 2020 Abhi Velaga. All rights reserved.
//

import UIKit
import CoreData

class NewPostViewController: UIViewController {
    
    @IBOutlet weak var semesterField: UITextField!
    @IBOutlet weak var reviewField: UITextView!
    @IBOutlet weak var easyAButton: UIButton!
    @IBOutlet weak var goodProfessorButton: UIButton!
    @IBOutlet weak var lightHomeworkButton: UIButton!
    @IBOutlet weak var projectHeavyButton: UIButton!
    @IBOutlet weak var actuallyUsefulButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var course_name = ""
    var id = 0
    var draftLoaded = false
    var easyA = false
    var goodProfessor = false
    var lightHomework = false
    var projectHeavy = false
    var actuallyUseful = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUIStyles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = "Give future students the inside scoop about \(course_name)!"
        retreiveDraft() // retreive draft saved in core data if it exists
        if darkMode {
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
    }
    
    func initUIStyles(){
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
    
    @IBAction func submit(_ sender: Any) {
        if semesterField.text != "", reviewField.text != "" {
            
            // previously loaded draft is finished and being submitted so delete it from core data
            if draftLoaded {
                deleteDraft()
            }
            draftLoaded = false
            
            // prepare json data with parameters
            let json: [String: Any] = ["courseId": id, "text":"\(reviewField!.text!)", "semester":"\(semesterField!.text!)","easyA": easyA,"good_professor": goodProfessor, "light_homework":lightHomework, "project_heavy": projectHeavy, "actually_useful": actuallyUseful]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            // create post request
            let url = URL(string: "\(rootUrl)/posts/create")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
            }
            
            task.resume()
            
            let controller = UIAlertController(
                title: "Submitted!",
                message: "Your review has been successfully submitted",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(title:"Okay",style:.default,handler:nil))
            self.present(controller, animated: true, completion: nil)
            reviewField.text = ""
            semesterField.text = ""
            setButtonAsUnselected(button: easyAButton)
            setButtonAsUnselected(button: goodProfessorButton)
            setButtonAsUnselected(button: lightHomeworkButton)
            setButtonAsUnselected(button: projectHeavyButton)
            setButtonAsUnselected(button: actuallyUsefulButton)
        }else{
            let controller = UIAlertController(
                title: "Error",
                message: "One or more of the fields is empty",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(title:"Okay",style:.default,handler:nil))
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func deleteDraft(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Draft")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let thisCourse = data.value(forKey: "course_name") as? String ?? ""
                
                // only delete if it's draft for this particular course
                if thisCourse == course_name {
                    context.delete(data)
                }
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
    
    func saveDraft() {
        let sem = semesterField.text
        let body = reviewField.text
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let d = NSEntityDescription.entity(forEntityName: "Draft", in: context)
        let newDraft = NSManagedObject(entity: d!, insertInto: context)
        
        newDraft.setValue(sem, forKey: "semester")
        newDraft.setValue(body, forKey: "body")
        newDraft.setValue(easyA, forKey: "easyA")
        newDraft.setValue(goodProfessor, forKey: "goodProfessor")
        newDraft.setValue(lightHomework, forKey: "lightHomework")
        newDraft.setValue(projectHeavy, forKey: "projectHeavy")
        newDraft.setValue(actuallyUseful, forKey: "actuallyUseful")
        newDraft.setValue(course_name, forKey: "course_name")
        let controller = UIAlertController(
            title: "Draft saved",
            message: "You can leave this screen and finish editing later",
            preferredStyle: .alert)
        controller.addAction(UIAlertAction(title:"Okay",style:.default,handler:nil))
        self.present(controller, animated: true, completion: nil)
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func retreiveDraft() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Draft")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let thisCourse = data.value(forKey: "course_name") as? String ?? ""
                
                // only load if it's draft for this particular course
                if thisCourse == course_name {
                    let sem = data.value(forKey: "semester") as? String ?? ""
                    let body = data.value(forKey: "body") as? String ?? ""
                    easyA = data.value(forKey: "easyA") as? Bool ?? false
                    goodProfessor = data.value(forKey: "goodProfessor") as? Bool ?? false
                    lightHomework = data.value(forKey: "lightHomework") as? Bool ?? false
                    projectHeavy = data.value(forKey: "projectHeavy") as? Bool ?? false
                    actuallyUseful = data.value(forKey: "actuallyUseful") as? Bool ?? false
                    
                    
                    if easyA {
                        setButtonAsSelected(button: easyAButton)
                    }
                    if goodProfessor {
                        setButtonAsSelected(button: goodProfessorButton)
                    }
                    if lightHomework {
                        setButtonAsSelected(button: lightHomeworkButton)
                    }
                    if projectHeavy {
                        setButtonAsSelected(button: projectHeavyButton)
                    }
                    if actuallyUseful {
                        setButtonAsSelected(button: actuallyUsefulButton)
                    }
                    
                    semesterField.text = sem
                    reviewField.text = body
                    draftLoaded = true
                }
                
            }
            
        } catch {
            print("Failed to retreive draft")
        }
    }
    
    @IBAction func draftPressed(_ sender: Any) {
        // we're saving new version of a draft, delete old version from core data first
        if draftLoaded {
            deleteDraft()
        }
        saveDraft()
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
