//
//  DetailViewController.swift
//  Inside Skoop
//  EID: ASV583
//  Course: CS371L
//
//  Created by Abhi Velaga on 7/5/20.
//  Copyright © 2020 Abhi Velaga. All rights reserved.
//

import UIKit

struct Post: Decodable {
    let url: URL
    let text: String
    let easyA: Bool
    let semester: String
    let good_professor: Bool
    let light_homework: Bool
    let project_heavy: Bool
    let actually_useful: Bool
    let course: URL
}

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PopoverGiver {
    
    var course: Course!
    var posts: [Post] = []
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var professorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorColor = UIColor.darkGray
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if authenticated {
            reviewButton.setTitle("Write a review", for: .normal)
            reviewButton.isEnabled = true
        }else{
            reviewButton.setTitle("Login in settings to leave a review", for: .normal)
            reviewButton.isEnabled = false
        }
        nameLabel.text = course!.course_name
        professorLabel.text = course!.professor_name
        getPosts()
        if darkMode {
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
    }
    
    // get list of available posts from backend
    func getPosts(){
        posts.removeAll()
        let id = course!.id
        let url = URL(string: "\(rootUrl)/posts/course/\(id)")
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
                self.posts = try! JSONDecoder().decode([Post].self, from: jsondata)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath as IndexPath) as! DetailTableViewCell
        let row = indexPath.row

        var tagOne:String!
        var tagTwo:String!
        
        if posts[row].easyA {
            tagOne = "Easy A"
        }
        if posts[row].good_professor {
            if tagOne == nil {
                tagOne = "Good Professor"
            }else if tagTwo == nil{
                tagTwo = "Good Professor"
            }
        }
        if posts[row].light_homework {
            if tagOne == nil {
                tagOne = "Light Homework"
            }else if tagTwo == nil{
                tagTwo = "Light Homework"
            }
        }
        if posts[row].project_heavy {
            if tagOne == nil {
                tagOne = "Project Heavy"
            }else if tagTwo == nil{
                tagTwo = "Project Heavy"
            }
        }
        if posts[row].actually_useful {
            if tagOne == nil {
                tagOne = "Actually Useful"
            }else if tagTwo == nil{
                tagTwo = "Actually Useful"
            }
        }
        
        if tagOne != nil {
            cell.tagOneText = tagOne!
        }
        if tagTwo != nil {
            cell.tagTwoText = tagTwo!
        }
        
        cell.review = posts[row].text
        cell.semester = posts[row].semester
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func refresh() {
        if authenticated {
            reviewButton.setTitle("Write a review", for: .normal)
            reviewButton.isEnabled = true
        }else{
            reviewButton.setTitle("Login in settings to leave a review", for: .normal)
            reviewButton.isEnabled = false
        }
        
        if(darkMode){
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReviewSegueID" {
            let destination = segue.destination as! NewPostViewController
            destination.course_name = course!.course_name
            destination.id = course!.id 
        }
        else if segue.identifier == "SettingsSegueID" {
            let destination = segue.destination as! SettingsViewController
            destination.delegate = self
        }
    }
    
}

class DetailTableViewCell: UITableViewCell {
    
    var tagOneText: String!
    var tagTwoText: String!
    var review: String!
    var semester: String!
    
    @IBOutlet weak var tagOne: UIButton!
    @IBOutlet weak var tagTwo: UIButton!
    @IBOutlet weak var semesterLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagOne.layer.cornerRadius = 13.0
        tagTwo.layer.cornerRadius = 13.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        tagOne.isHidden = true
        tagTwo.isHidden = true
        super.setSelected(selected, animated: animated)
        if let text = tagOneText {
            tagOne.setTitle(text, for: .normal)
            tagOne.isHidden = false
        }
        
        if let text = tagTwoText {
            tagTwo.setTitle(text, for: .normal)
            tagTwo.isHidden = false
        }
        
        reviewLabel.text = review!
        semesterLabel.text = semester!
        
    }
}
