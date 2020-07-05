//
//  DetailViewController.swift
//  Inside Skoop
//
//  Created by Abhi Velaga on 7/5/20.
//  Copyright © 2020 Abhi Velaga. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let reviews = [(semester: "Spring 2020", tagOne: "Easy A", tagTwo: "Test Heavy", review: "oh my god so hard oh my god so hard oh my god so hard oh my god so hard "), (semester: "Fall 2020", tagOne: "Good Professor", tagTwo: "Test Heavy", review: "best ever yes very good best ever yes very good best ever yes very good "), (semester: "Summer 3020", tagOne: "Actually Useful", tagTwo: "Project Heavy", review: "oh my god so hard oh my god so hard oh my god so hard oh my god so hard ")]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorColor = UIColor.darkGray
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath as IndexPath) as! DetailTableViewCell
        let row = indexPath.row
        cell.tagOneText = reviews[row].tagOne
        cell.tagTwoText = reviews[row].tagTwo
        cell.review = reviews[row].review
        cell.semester = reviews[row].semester
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
