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
    //MARK: - SINGLETON EXAMPLE
    static var timelineCellIdentifier = "timelineCell"
    static var addProjectCellIdentifier = "addProjectCell"
    
    //This is a weak variable because it prevents memory leaks
    weak var delegate: TimelineViewControllerDelegate?

    var scheduler = Scheduler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Timeline"
    
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(TimelineCell.self, forCellReuseIdentifier: TimelineViewController.timelineCellIdentifier)
        self.tableView.register(AddProjectCell.self, forCellReuseIdentifier: TimelineViewController.addProjectCellIdentifier)
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
        tableView.tableFooterView = UIView()
        //MARK: - STRATEGY EXAMPLE
        refreshTimeline()
        self.tableView.reloadData()
    }
    
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
        //DO NOT CHANGE - Milestones Cells + Add Milestone Cell
        return (scheduler.getMilestoneCount() + 1)
    }
    
    //MARK: - FACTORY EXAMPLE
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != (tableView.numberOfRows(inSection: tableView.numberOfSections - 1) - 1){
            let milestones = scheduler.getMilestones()
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "timelineCell", for: indexPath) as? TimelineCell else {
                fatalError("Unable to dequeue Timelinecell")
            }
            cell.milestone = milestones[indexPath.row]
            cell.backgroundColor = mainColor
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TimelineViewController.addProjectCellIdentifier, for: indexPath) as? AddProjectCell else {
                fatalError("unable to dequeue AddProjectCell")
            }
            cell.delegate = self.delegate
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != (tableView.numberOfRows(inSection: tableView.numberOfSections - 1) - 1){
            return 100
        } else {
            return 43
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //Helper functions
    @objc func refreshTimeline() {
        scheduler.queryMilestones() //this happens sequentially, so that it queries the miletones, sorts them, and then updates the timeline AFTER that is all done
    }
}




//INDIVIDUAL CELLS
//adapted from https://github.com/kemalekren/Sample-Custom-TableView-Project-/blob/master/Sample_TableView
class TimelineCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
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
        label.textColor = .systemPurple
        label.font = UIFont(name: "Futura-Medium", size: 16)
        return label
    }()
    
    private let projectNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1) //start dark gray
        label.font = UIFont(name: "Futura-Medium", size: 16)
        return label
    }()
    
    private let milestoneDifficultyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemPurple
        label.font = UIFont(name: "Futura-Medium", size: 16)
        return label
    }()
    
    private let milestoneDueDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemPurple
        label.font = UIFont(name: "Futura-Medium", size: 16)
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
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AddProjectCell: UITableViewCell {
    
    //This is a weak variable because it prevents memory leaks
    weak var delegate: TimelineViewControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func didTapNewProjectButton() {
        delegate?.didTapNewProjectButton()
    }
    
    private let addProjectButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .systemPurple
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(addProjectButton)
        addProjectButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0, enableInsets: false)
        addProjectButton.addTarget(self, action: #selector(didTapNewProjectButton), for: .touchUpInside)
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
        //reference from: https://firebase.google.com/docs/firestore
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
    
    //returns the sorted milestones from the projectDict
    func sortAndParseMilestones() {
        milestones.removeAll()
        for (_, value) in schedulerStruct.projectDict {
            milestones.append(contentsOf: value.1)
        }
        milestones.sort {
            $0.getMilestoneRankingAlgorithmIndex(milestone: $0) < $1.getMilestoneRankingAlgorithmIndex(milestone: $1)
        }
        milestoneCount = milestones.count
        timelineTableView.reloadData() //reload the timeline cells once we have sorted the milestones and the data is ready!
    }
}

extension Milestone {
    //MARK: - SORTING ALGORITHM 1
    // Create interval from current date to milestone due date
    // Interval Time (in seconds) / Milestone DIfficulty Rating
    
    func getMilestoneRankingAlgorithmIndex(milestone: Milestone) -> Double {
        let timeInterval = milestone.milestoneDueDate.timeIntervalSinceNow
//        print("\(milestone.milestoneName): Milestone Difficulty Rating: \(milestone.milestoneDifficultyRating) TimeInterval: \(Int(timeInterval)) Ranking Index - \(Double(timeInterval) / Double(milestone.milestoneDifficultyRating))")
        return Double(timeInterval)/Double(milestone.milestoneDifficultyRating)
    }
}
