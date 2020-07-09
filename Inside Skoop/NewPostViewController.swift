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
    
    @IBOutlet weak var titleLabel: UILabel!
    var course_name = ""
    var id = 0
    var draftLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func submit(_ sender: Any) {
        if semesterField.text != "", reviewField.text != "" {
            
            // previously loaded draft is finished and being submitted so delete it from core data
            if draftLoaded {
                deleteDraft()
            }
            draftLoaded = false
            
            // prepare json data
            let json: [String: Any] = ["courseId": id,
                                       "text":"\(reviewField!.text!)","semester":"\(semesterField!.text!)"]
            
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
    
    func saveDraft() {
        let sem = semesterField.text
        let body = reviewField.text
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let d = NSEntityDescription.entity(forEntityName: "Draft", in: context)
        let newDraft = NSManagedObject(entity: d!, insertInto: context)
        newDraft.setValue(sem, forKey: "semester")
        newDraft.setValue(body, forKey: "body")
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
                let sem = data.value(forKey: "semester") as! String
                let body = data.value(forKey: "body") as! String
                semesterField.text = sem
                reviewField.text = body
                draftLoaded = true
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
