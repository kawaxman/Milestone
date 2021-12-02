//
//  TimelineViewController.swift
//  milestone
//
//  Created by Kent Waxman on 11/9/21.
//

import UIKit
import SwiftUI
import FirebaseAuth
import Firebase

//This allows us to communicate back to the Container View
protocol TimelineViewControllerDelegate: AnyObject {
    func didTapSideMenuButton()
    func didTapNewTaskButton()
}

class TimelineViewController: UITableViewController {
    static var timelineCellIdentifier = "timelineCell"
    
    //This is a weak variable because it prevents memory leaks
    weak var delegate: TimelineViewControllerDelegate?
    
    let scheduler = Scheduler()

    
//    @IBOutlet var milestoneName: UILabel!
//    @IBAction func refreshMilestoneButton(_ sender: Any) {
//        milestoneName.text = "Milestone1"
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Timeline"
        //Based from afformentioned youtube video on side bar (normally We do this in the story board view)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapSideMenuButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapNewTaskButton))
        scheduler.queryMilestones()
    }
    
    @objc func didTapSideMenuButton() {
        delegate?.didTapSideMenuButton()
    }
    
    @objc func didTapNewTaskButton() {
        delegate?.didTapNewTaskButton()
    }
    
    @IBAction func unwindToTimelineViewController(segue: UIStoryboardSegue) {
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduler.getMilestoneDictCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(TimelineCell.self, forCellReuseIdentifier: TimelineViewController.timelineCellIdentifier)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimelineViewController.timelineCellIdentifier, for: indexPath) as? TimelineCell else {
            fatalError("Unable to dequeue Timelinecell")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43
    }
    
}

class TimelineCell: UITableViewCell {
    @IBOutlet weak var milestoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class Scheduler {
    var db = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    
    //Dictionary key is userID
    var milestoneDict = [String : [Milestone]]()
    
    func queryMilestones() {
        print("Scheduler running...")
        db.collection(userID!).getDocuments(completion: { [self](querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
//                    let dataDescription = document.data()
//                    print("\(document.documentID) => \(document.data())")
                    //get milestone data
//                    let milestones = document.data()["milestones"] ?? [""] as [Array<Any>]
//                    let mediaDict = restDict["media"] as! [[String:Any]]
                    let milestones = document.data()["milestones"] as! [[String:Any]]
                    for milestone in milestones {
                        let currentMilestone = Milestone(
                            projectName: document.documentID,
                            milestoneName: milestone["milestoneName"] as! String,
                            milestoneDueDate: (milestone["milestoneDueDate"] as! Timestamp).dateValue(),
                            milestoneDifficultyRating: milestone["milestoneDifficultyRating"] as! Int)
                        if (self.milestoneDict[self.userID!] != nil) {
                            self.milestoneDict[self.userID!]?.append(currentMilestone)
                        } else {
                            self.milestoneDict[self.userID!] = [currentMilestone]
                        }
                    }
                    print("Milestones Queried:", milestoneDict)

//                    guard let milestoneName = dataDescription["milestoneName"] else { return }
//                    guard let milestoneDifficultyRating = dataDescription["milestoneDifficultyRating"] else { return }
//                    guard let milestoneDueDate = dataDescription["milestoneDueDate"] as? Timestamp else { return }
//                    guard let projectName = dataDescription["projectName"] else { return }
//
//                    let collectedMilestone = Milestone(projectName: projectName as! String, milestoneName: milestoneName as! String, milestoneDueDate: milestoneDueDate.dateValue(), milestoneDifficultyRating: milestoneDifficultyRating as! Int)
//
//                    if (self.milestoneDict[self.userID!] != nil) {
//                        self.milestoneDict[self.userID!]?.append(collectedMilestone)
//                    } else {
//                        self.milestoneDict[self.userID!] = [collectedMilestone]
//                    }
                }
            }
        })
    }
    
    //helper methods
    func getMilestoneDictCount() -> Int {
        return milestoneDict.count
    }
}
