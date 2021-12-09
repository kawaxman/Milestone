//
//  ProjectViewController.swift
//  milestone
//
//  Created by Kent Waxman on 11/26/21.
//

import Foundation
import SwiftUI

//MARK: - SINGLETON EXAMPLE
class ProjectViewController: UIViewController {
    
    @IBOutlet weak var projectInputTextField: UITextField!
    @IBOutlet weak var projectDueDateInput: UIDatePicker!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.tintColor = .white
        cancelButton.tintColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
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
