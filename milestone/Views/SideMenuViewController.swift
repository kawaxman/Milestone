//
//  SideMenuViewController.swift
//  milestone
//
//  Created by Josh Creany on 11/16/21.
//
import UIKit
import SwiftUI

//This allows us to communicate back to the Container View
protocol SideMenuViewControllerDelegate: AnyObject {
    func didSelect(sideMenuItem: SideMenuViewController.SideMenuOptions)
}


class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let userSecondaryColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
    
    weak var delegate: SideMenuViewControllerDelegate?
    
    enum SideMenuOptions: String, CaseIterable {
        //Since these are iterable, the order of these matter because the Side Menu will create the table view cells based on their order
        case timeline = "Timeline"
        case calendar = "Calendar"
        case darkMode = "Dark Mode"
        case logOut = "Log Out"
        
        var imageName: String {
            switch self {
                
            case .timeline:
                return "clock"
            case .calendar:
                return "calendar"
            case .darkMode:
                return "moon"
            case .logOut:
                return "arrow"
            }
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = nil //We don't want the table view frame to be visible
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell") //this is the plain table view cell, we can edit this later if we want a different cell type
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView) //this adds the table view to our side menu
        //These next two lines allow the table view to
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = userSecondaryColor
    }
    
    //This gives our Table View a frame within the Side Menu View
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height)
    }
    
    //Filling in the table view cells from the menu options we just made
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SideMenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //This goes through all cells and inputs their corresponding value in the SideMenuOptions cases
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = SideMenuOptions.allCases[indexPath.row].rawValue
        cell.textLabel?.textColor = .white
        cell.imageView?.image = UIImage(systemName: SideMenuOptions.allCases[indexPath.row].imageName) //This gets each image from the SideMenuOptions and put the corresponding image into each cell
        cell.imageView?.tintColor = .white //This makes the images match the textß
        cell.backgroundColor = userSecondaryColor
        cell.contentView.backgroundColor = userSecondaryColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //This will unhighlight the Side Menu Options
        tableView.deselectRow(at: indexPath, animated: true)
        
        //When we select an item, tell the delegate which one we selected and use that to communicate back to the containerViewController
        let item = SideMenuOptions.allCases[indexPath.row]
        delegate?.didSelect(sideMenuItem: item)
    }
}
