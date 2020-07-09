//
//  ListViewController.swift
//  Inside Skoop
//  EID: ASV583
//  Course: CS371L
//
//  Created by Abhi Velaga on 7/5/20.
//  Copyright © 2020 Abhi Velaga. All rights reserved.
//

import UIKit

struct Course: Decodable {
    let id: Int
    let department: URL
    let course_number: String
    let professor_name: String
    let course_name: String
}

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PopoverGiver {
    
    @IBOutlet weak var tableView: UITableView!
    
    var courses: [Course] = []
    var query = ""
    var department = "All Departments"
    var easyA = false
    var goodProfessor = false
    var lightHomework = false
    var projectHeavy = false
    var actuallyUseful = false
    
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCourses()
        if darkMode {
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
    }
    
    func getCourses(){
        if department == "All Departments" {
            department = ""
        }
        
        var params = "?"
        if query != "" {
            params += "&query=\(query)"
        }
        if department != "" {
            params += "&department=\(department)"
        }
        if easyA {
            params += "&easyA=true"
        }
        if goodProfessor {
            params += "&goodProfessor=true"
        }
        if lightHomework {
            params += "&lightHomework=true"
        }
        if projectHeavy {
            params += "&projectHeavy=true"
        }
        if actuallyUseful {
            params += "&actuallyUseful=true"
        }
        
        courses.removeAll()
        let url = URL(string: "\(rootUrl)/courses\(params)")
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
                self.courses = try! JSONDecoder().decode([Course].self, from: jsondata)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath as IndexPath) as! ResultTableViewCell
        let row = indexPath.row
        
        var one = ""
        var two = ""
        
        if easyA {
            one = "Easy A"
        }
        if goodProfessor {
            if one == "" {
                one = "Good Professor"
            }else{
                two = "Good Professor"
            }
        }
        if lightHomework {
            if one == "" {
                one = "Light Homework"
            }else{
                two = "Light Homework"
            }
        }
        if projectHeavy {
            if one == "" {
                one = "Project Heavy"
            }else{
                two = "Project Heavy"
            }
        }
        if actuallyUseful {
            if one == "" {
                one = "Actually Useful"
            }else{
                two = "Actually Useful"
            }
        }
        
        if one != "" {
            cell.tagOneText = one
        }
        if two != "" {
            cell.tagTwoText = two
        }
        cell.courseName = courses[row].course_name
        cell.professor = courses[row].professor_name
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRow = indexPath.row
        performSegue(withIdentifier: "DetailSegueID", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func refresh() {
        if(darkMode){
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegueID" {
            // send search parameters to list view vc
            let destination = segue.destination as! DetailViewController
            destination.course = courses[selectedRow]
        }
        else if segue.identifier == "SettingsSegueID" {
            let destination = segue.destination as! SettingsViewController
            destination.delegate = self
        }
    }
}

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var border: UIButton!
    @IBOutlet weak var tagOne: UIButton!
    @IBOutlet weak var tagTwo: UIButton!
    
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var professorLabel: UILabel!
    
    var tagOneText: String!
    var tagTwoText: String!
    var courseName = ""
    var professor = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagOne.isHidden = true
        tagTwo.isHidden = true
        border.layer.cornerRadius = 45.0
        border.layer.borderWidth = 1.0
        border.layer.borderColor = UIColor.lightGray.cgColor
        
        tagOne.layer.cornerRadius = 13.0
        tagTwo.layer.cornerRadius = 13.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        courseNameLabel.text = courseName
        professorLabel.text = professor
        border.isEnabled = false // disable button being used for border
        super.setSelected(selected, animated: animated)
        if let text = tagOneText {
            tagOne.setTitle(text, for: .normal)
            tagOne.isHidden = false
        }
        
        if let text = tagTwoText {
            tagTwo.setTitle(text, for: .normal)
            tagTwo.isHidden = false
        }
    }
}
