//
//  ProjectViewController.swift
//  milestone
//
//  Created by Kent Waxman on 11/26/21.
//

import Foundation
import SwiftUI

class ProjectViewController: UIViewController {
    
    @IBOutlet weak var projectInputTextField: UITextField!
    @IBOutlet weak var projectDueDateInput: UIDatePicker!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "projectToMilestone" {
            if let milestoneVC = segue.destination as? MilestoneViewController {
                milestoneVC.projectName = projectInputTextField.text ?? ""
                milestoneVC.projectDueDate = projectDueDateInput.date
            }
        }
    }
}
