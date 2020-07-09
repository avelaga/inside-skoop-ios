//
//  NewPostViewController.swift
//  Inside Skoop
//
//  Created by Abhi Velaga on 7/5/20.
//  Copyright © 2020 Abhi Velaga. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {
    
    @IBOutlet weak var semesterField: UITextField!
    @IBOutlet weak var reviewField: UITextView!
    
    @IBOutlet weak var titleLabel: UILabel!
    var course_name = ""
    var id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = "Give future students the inside scoop about \(course_name)!"
        if darkMode {
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        
        if semesterField.text != "", reviewField.text != "" {
            
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
    
}
