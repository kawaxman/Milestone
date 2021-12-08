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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.tintColor = accentColor
        cancelButton.tintColor = accentColor
//        projectDueDateInput.anchor(top: projectInputTextField.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0, enableInsets: false)
//        projectDueDateInput.frame = CGRect(x: self.frame.size.width, y: <#T##Double#>, width: <#T##Double#>, height: <#T##Double#>)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "projectToMilestone" {
            if let milestoneVC = segue.destination as? MilestoneViewController {
                milestoneVC.projectName = projectInputTextField.text ?? ""
                milestoneVC.projectDueDate = projectDueDateInput.date
            }
        }
    }
}
