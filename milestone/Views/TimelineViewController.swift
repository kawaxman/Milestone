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
    
    //This is a weak variable because it prevents memory leaks
    weak var delegate: TimelineViewControllerDelegate?
    
//    @IBOutlet var milestoneName: UILabel!
//    @IBAction func refreshMilestoneButton(_ sender: Any) {
//        milestoneName.text = "Milestone1"
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Timeline"
        view.backgroundColor = .systemGreen
        
        //Based from afformentioned youtube video on side bar (normally We do this in the story board view)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapSideMenuButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapNewTaskButton))
    }
    
    @objc func didTapSideMenuButton() {
        delegate?.didTapSideMenuButton()
    }
    
    @objc func didTapNewTaskButton() {
        delegate?.didTapNewTaskButton()
    }
    
    @IBAction func unwindToTimelineViewController(segue: UIStoryboardSegue) {
    }
}
