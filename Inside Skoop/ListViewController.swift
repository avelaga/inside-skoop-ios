//
//  ListViewController.swift
//  Inside Skoop
//
//  Created by Abhi Velaga on 7/5/20.
//  Copyright © 2020 Abhi Velaga. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let results = [(one: "a",two: "b"), (one:"c",two: "d"), (one:"e", two:"f"), (one:"g",two: "h")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if darkMode {
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath as IndexPath) as! ResultTableViewCell
        let row = indexPath.row
        cell.tagOneText = results[row].one
        cell.tagTwoText = results[row].two
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var border: UIButton!
    @IBOutlet weak var tagOne: UIButton!
    @IBOutlet weak var tagTwo: UIButton!
    
    var tagOneText: String!
    var tagTwoText: String!
    
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
