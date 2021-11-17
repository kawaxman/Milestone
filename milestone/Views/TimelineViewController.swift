//
//  TimelineViewController.swift
//  milestone
//
//  Created by Kent Waxman on 11/9/21.
//

import UIKit
import SwiftUI

//This allows us to communicate back to the Container View
protocol TimelineViewControllerDelegate: AnyObject {
    func didTapSideMenuButton()
}

class TimelineViewController: UITableViewController {
    //Use this for the amount of cells that the firebase query returns to load
    
    //This is a weak variable because it prevents memory leaks
    weak var delegate: TimelineViewControllerDelegate?
    
    @IBOutlet var milestoneName: UILabel!
    @IBAction func refreshMilestoneButton(_ sender: Any) {
        milestoneName.text = "Milestone1"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Timeline"
        view.backgroundColor = .systemRed
        
        //Based from afformentioned youtube video on side bar (normally We do this in the story board view)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapSideMenuButton))
    }
    
    @objc func didTapSideMenuButton() {
        delegate?.didTapSideMenuButton()
    }
}
