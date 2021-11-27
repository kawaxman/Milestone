//
//  MilestoneViewController.swift
//  milestone
//
//  Created by Kent Waxman on 11/26/21.
//

import Foundation
import SwiftUI

class MilestoneViewController: UITableViewController {
    static let milestoneCellIdentifier = "milestoneCell"
    static let addMilestoneCellIdentifier = "addMilestoneCell"
    
    var cellCount = 2
    
    @IBAction func addAnotherMilestone(_ sender: Any) {
        cellCount+=1
        self.tableView.reloadData()
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
