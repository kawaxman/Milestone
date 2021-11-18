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
}

class TimelineViewController: UITableViewController {
    //Use this for the amount of cells that the firebase query returns to load
    //Create DB Reference
    var db = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    
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
    }
    
    @objc func didTapSideMenuButton() {
        delegate?.didTapSideMenuButton()
        //TODO- Use this for query selection + document and collection creation
//        self.db.collection(userID!).document("Project Name").setData(["Milestone": "take out the trash"])
//        self.db.collection(userID!).getDocuments(completion: { (QuerySnapshot, err) in
//            if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in QuerySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
//                    }
//                }
//        })
    }
}
