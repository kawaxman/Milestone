//
//  MilestoneViewController.swift
//  milestone
//
//  Created by Kent Waxman on 11/26/21.
//

import Firebase
import Foundation
import UIKit

struct Milestone {
    var projectName: String
    var milestoneName: String
    var milestoneDueDate: Date
    var milestoneDifficultyRating: Int
}

class MilestoneViewController: UITableViewController {
    static let milestoneCellIdentifier = "milestoneCell"
    static let addMilestoneCellIdentifier = "addMilestoneCell"
    
    var projectName = ""
    var cellCount = 2
    
    //Use this for the amount of cells that the firebase query returns to load
    //Create DB Reference
    var db = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    
    @IBAction func addAnotherMilestone(_ sender: Any) {
        cellCount+=1
        self.tableView.reloadData()
    }
    
    @IBAction func submitMilestones(_ sender: Any) {
        aggregateData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //DO NOT CHANGE- First milestone cell + add new milestone cell cells
        return self.cellCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != (tableView.numberOfRows(inSection: tableView.numberOfSections - 1) - 1){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MilestoneViewController.milestoneCellIdentifier, for: indexPath) as? MilestoneCell else {
                fatalError("unable to dequeue milestoneCell")
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MilestoneViewController.addMilestoneCellIdentifier, for: indexPath) as? AddMilestoneCell else {
                fatalError("unable to dequeue milestoneCell")
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != (tableView.numberOfRows(inSection: tableView.numberOfSections - 1) - 1){
            return 301
        } else {
            return 43
        }
    }
    
    //pragma mark- HELPER METHODS
    func aggregateData() {
        var milestones = [Milestone]()
        for cell in self.tableView.visibleCells {
            if (cell.reuseIdentifier == MilestoneViewController.milestoneCellIdentifier) {
                let tempCell = cell as! MilestoneCell
                milestones.append(Milestone(projectName: projectName,
                                            milestoneName: tempCell.milestoneTextField.text ?? "",
                                            milestoneDueDate: tempCell.milestoneDatePicker.date,
                                            milestoneDifficultyRating: (tempCell.milestoneDifficultyRating.selectedSegmentIndex + 1)))
            }
        }
        pushData(m: milestones)
    }
    
    func pushData(m: [Milestone]) {
        //for query selection + document and collection creation
//        for milestone in m {
//            self.db.collection(userID!).document().setData(["taskName" : milestone.taskName,
//                                                            "milestoneName" : milestone.milestoneName,
//                                                            "milestoneDueDate" : milestone.milestoneDueDate,
//                                                            "milestoneDifficultyRating" : milestone.milestoneDifficultyRating])
//        }
//        self.db.collection(userID!).document(projectName).setData(["milestones" : [:]])
        for milestone in m {
            let currentMilestoneData = ["milestoneName": milestone.milestoneName,
                                        "milestoneDueDate": milestone.milestoneDueDate,
                                        "milestoneDifficultyRating": milestone.milestoneDifficultyRating] as [String : Any]
            let db = self.db.collection(userID!).document(projectName)
            db.setData(["milestones": FieldValue.arrayUnion([currentMilestoneData])], merge: true)
            { err in
                if let err = err {
                    print("Error adding milestone data: \(err)")
                }
            }
        }
        self.db.collection(userID!).getDocuments(completion: { (QuerySnapshot, err) in
            if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.performSegue(withIdentifier: "unwindToTimeline", sender: self)
                }
        })
    }
}

class MilestoneCell: UITableViewCell {
        
    @IBOutlet weak var milestoneTextField: UITextField!
    @IBOutlet weak var milestoneDatePicker: UIDatePicker!
    @IBOutlet weak var milestoneDifficultyRating: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class AddMilestoneCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
