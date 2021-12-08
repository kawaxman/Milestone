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
    func didTapNewProjectButton()
}

var timelineTableView: UITableView = UITableView()

class TimelineViewController: UITableViewController {
    static var timelineCellIdentifier = "timelineCell"
    
    //This is a weak variable because it prevents memory leaks
    weak var delegate: TimelineViewControllerDelegate?

    var scheduler = Scheduler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Timeline"
    
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(TimelineCell.self, forCellReuseIdentifier: "timelineCell")
        //Based from afformentioned youtube video on side bar (normally We do this in the story board view)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapSideMenuButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(refreshTimeline))
        navigationItem.leftBarButtonItem?.tintColor = accentColor
        navigationItem.rightBarButtonItem?.tintColor = accentColor
        timelineTableView = tableView
        refreshTimeline()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        refreshTimeline()
    }
    
//    @objc func passTableView() {
//        delegate?.self.tableView
//    }
    
    @objc func didTapSideMenuButton() {
        delegate?.didTapSideMenuButton()
    }
    
    @objc func didTapNewProjectButton() {
        delegate?.didTapNewProjectButton()
    }
    
    //Can we make another function that doesn't always refresh the timeline upon a segue?
    @IBAction func unwindToTimelineViewController(segue: UIStoryboardSegue) {
//        print("revealing timeline again...")
        if (segue.source.isKind(of: MilestoneViewController.self)) {
            refreshTimeline()
        }
    }
    
    
    
    //Loading ALL TIMELINE CELLS
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduler.getMilestoneCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let milestones = scheduler.getMilestones()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "timelineCell", for: indexPath) as? TimelineCell else {
            fatalError("Unable to dequeue Timelinecell")
        }
        cell.milestone = milestones[indexPath.row]
        cell.backgroundColor = mainColor
//        print("Cell Milestone Label:",milestones[indexPath.row].milestoneName)
//        cell.contentView.backgroundColor = UIColor(red: 255/255.0, green: 100/255.0, blue: 100/255.0, alpha: 1)
//        cell.backgroundColor = mainColor
//        cell.textLabel?.text = milestones[indexPath.row].milestoneName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //setting up the footer for the "Add New Project" button
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        footerView.backgroundColor = secondColor.withAlphaComponent(1) //if we want it to be transparent, change alpha below 1
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(didTapNewProjectButton), for: .touchUpInside)
        button.frame = CGRect(x: footerView.center.x - 25, y: 0, width: 50, height: 50)
        button.tintColor = accentColor
        footerView.addSubview(button)
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //Helper functions
    
    @objc func refreshTimeline() {
//        DispatchQueue.main.async {
//            self.scheduler.queryMilestones()
//            self.tableView.reloadData()
//        }
        scheduler.queryMilestones()
//        self.tableView.reloadData()
//        self.tableView.reloadData()
    }
}




//INDIVIDUAL CELLS
//adapted from https://github.com/kemalekren/Sample-Custom-TableView-Project-/blob/master/Sample_TableView
class TimelineCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        milestoneNameLabel.textColor = primaryTextColor
        projectNameLabel.textColor = secondaryTextColor
        milestoneDifficultyLabel.textColor = primaryTextColor
        milestoneDueDateLabel.textColor = primaryTextColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var milestone : Milestone? {
        //this sets the values of the UI elements we create below based on what is in the struct
        didSet {
            milestoneNameLabel.text = milestone?.milestoneName
            projectNameLabel.text = milestone?.projectName
            if let diffRatingInt = milestone?.milestoneDifficultyRating {
                milestoneDifficultyLabel.text = String(diffRatingInt)
            }
            
            let dateFormatter = DateFormatter() // Create Date Formatter
            dateFormatter.dateStyle = .short //Set Date style
            dateFormatter.timeStyle = .short //set Time style
            if let unformattedDate: Date = milestone?.milestoneDueDate { //Convert Date to String
                milestoneDueDateLabel.text = dateFormatter.string(from: unformattedDate)
            }
        }
    }
    
    private let milestoneNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = primaryTextColor
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let projectNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = secondaryTextColor
        return label
    }()
    
    private let milestoneDifficultyLabel: UILabel = {
        let label = UILabel()
        label.textColor = primaryTextColor
        return label
    }()
    
    private let milestoneDueDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = primaryTextColor
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(milestoneNameLabel)
        milestoneNameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0, enableInsets: false)
        
        addSubview(projectNameLabel)
        projectNameLabel.anchor(top: milestoneNameLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 15, paddingRight: 5, width: 0, height: 0, enableInsets: false)
        
        addSubview(milestoneDifficultyLabel)
        milestoneDifficultyLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0, enableInsets: false)
        
        addSubview(milestoneDueDateLabel)
        milestoneDueDateLabel.anchor(top: milestoneDifficultyLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0, enableInsets: false)
        
//        let stackView = UIStackView(arrangedSubviews: [milestoneNameLabel, projectNameLabel])
//        stackView.distribution = .equalSpacing
//        stackView.axis = .vertical
//        stackView.spacing = 5
//        addSubview(stackView)
//        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 15, paddingRight: 5, width: 0, height: 0, enableInsets: false)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct SchedulerStruct {
    //Dictionary key is userID#imageLiteral(resourceName: "simulator_screenshot_3E35AA14-ADD2-4B5B-9FDB-92A049EA77A4.png")
    var projectDict: [String: (Any, [Milestone])] = [:] //a project name (first string) has its own due date (Any) and multiple Milestones inside of it ([Milestone])
}

class Scheduler {
    var db = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    var milestones: [Milestone] = [] //should this list is sorted after a call to "Sort Milestones"
    var milestoneCount = 0
    var schedulerStruct: SchedulerStruct
    
    init() {
        self.schedulerStruct = SchedulerStruct()
    }
        
    func queryMilestones() {
        print("Scheduler running...")
        db.collection(userID!).getDocuments(completion: { [self](querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let projectDueDate = document.data()["projectDueDate"] ?? Date()
                    var milestones = [Milestone]()
                    guard let unparsedMilestones = document.data()["milestones"] as? [[String:Any]] else {
                        print("No milestones were found in \(document.documentID)")
                        return
                    }
                    for milestone in unparsedMilestones {
                        let currentMilestone = Milestone(
                            projectName: document.documentID,
                            milestoneName: milestone["milestoneName"] as! String,
                            milestoneDueDate: (milestone["milestoneDueDate"] as! Timestamp).dateValue(),
                            milestoneDifficultyRating: milestone["milestoneDifficultyRating"] as! Int)
                        milestones.append(currentMilestone)
                    }
                    schedulerStruct.projectDict[document.documentID] = (projectDueDate, milestones)
                }
//                print("Projects Queried:", schedulerStruct.projectDict) //for some reason, the projectDueDate doesn't show up as a "date" datatype but is just fine in Firebase... weird
                sortAndParseMilestones()
            }
        })
    }
    
    func getMilestones() -> [Milestone] {
        return milestones
    }
    
    func getMilestoneCount() -> Int {
        return milestoneCount
    }
    
    //helper methods
    func getProjectDictCount() -> Int {
        print(schedulerStruct.projectDict.count)
        return schedulerStruct.projectDict.count
    }
    
    //returns the sorted milestones from the projectDict (CURRENTLY NO SORTING IS DONE)
    func sortAndParseMilestones() {
        milestones.removeAll()
        for (_, value) in schedulerStruct.projectDict {
            milestones.append(contentsOf: value.1)
        }
        milestoneCount = milestones.count
        
        timelineTableView.reloadData() //reload the timeline cells once we have sorted the milestones and the data is ready!
    }
}
