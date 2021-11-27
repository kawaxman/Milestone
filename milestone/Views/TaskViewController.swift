//
//  TaskViewController.swift
//  milestone
//
//  Created by Kent Waxman on 11/26/21.
//

import Foundation
import SwiftUI

class TaskViewController: UIViewController {
    
    @IBOutlet weak var taskInputTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "taskToMilestone" {
            if let milestoneVC = segue.destination as? MilestoneViewController {
                milestoneVC.taskName = taskInputTextField.text ?? ""
            }
        }
    }
}
