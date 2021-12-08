//
//  ContainerViewController.swift
//  milestone
//
//  Created by Josh Creany on 11/17/21.
//

import Firebase
import FirebaseAuth
import UIKit
import SwiftUI

//This class holds the main views for the apps
//This includes:
// - Timeline View
// - Side Menu View
// - Calendar View (In the future)
// - etc....
class ContainerViewController: UIViewController {

    enum  SideMenuState {
        case opened
        case closed
    }
    
    private var sideMenuState: SideMenuState = .closed //by default, our side menu is closed
    
    let sideMenuVC = SideMenuViewController()
    let timelineVC = TimelineViewController()
    var navVC: UINavigationController?
    lazy var calendarVC = CalendarViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        
        //Found from youtube video on adding a side menu bar: youtube.com/watch?v=1hzPFAYcuUI
        addChildVCs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func addChildVCs() {
        //The order of these matters! This is the order that the views are placed inside the container view
        // Side Menu
        sideMenuVC.delegate = self //this is where we connect the two views
        addChild(sideMenuVC)
        view.addSubview(sideMenuVC.view)
        sideMenuVC.didMove(toParent: self) //The side menu is now a child of the container controller
        
        // Timeline View (Loaded on top of the Side Menu)
        timelineVC.delegate = self //this is where we connect the two views
        //refresh timeline before the timelineVC is added as a child
        timelineVC.refreshTimeline()
        let navVC = UINavigationController(rootViewController: timelineVC) //this wraps our timeline view in a navigation view, since we want a nav bar at the top
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self) //The timelineView is now a child of the container controller
        self.navVC = navVC //set the local navVC variable to the navVC we wrapped the timeline in so that we can make the nav bar move with the side menu animation
    }
}

//This makes the Container View a delegate for the timeline view controller, which allows communication between them
extension ContainerViewController: TimelineViewControllerDelegate {
    //This is like inheritance in a sense, we must implement the "didTapSideMenuButton" in order to conform to the design contract
    func didTapSideMenuButton() {
        toggleSideMenu(completion: nil) //In this case, we don't want a completion handler
    }
    
    func didTapNewProjectButton() {
        performSegue(withIdentifier: "timelineToAddProject", sender: self)
    }
    
    //This is the actual code for sliding the menu in and out. We input a completion handler in the parameters for when we want the Container View to not only slide the menu in and out, but to optionally change views, etc. if the location that called it needs that (such as clicking on the calendar button in the side menu)
    func toggleSideMenu(completion: (() -> Void)?) {
        //Animate the menu (the way this works is we slide over the top view (Timeline View Controller) and reveal the Side Menu View Controller)
        switch sideMenuState {
        case .closed:
            //Open the side menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                //This is the actual movement of the view, where we move the view that is wrapped in the navigation view (ideally we should change the 100 pixels to a value based on the device we are on)
                self.navVC?.view.frame.origin.x = self.timelineVC.view.frame.size.width - 100
            } completion: { [weak self] done in
                if done {
                    //When the opening animation is done, we need to do update the state to "open"
                    self?.sideMenuState = .opened
//                    print("side bar is opened")
                }
            }

        case .opened:
            //Close the side menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                //This is the actual movement of the view, where we move the view that is wrapped in the navigation view (ideally we should change the 100 pixels to a value based on the device we are on)
                self.navVC?.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    //When the opening animation is done, we need to do update the state to "closed"
                    self?.sideMenuState = .closed
//                    print("side bar is closed")
                    DispatchQueue.main.async {
//                        print("Attempting completion/callback handler")
                        completion?() //This is where we call the additional functionality if needed (must be done on the main UI thread so that the views are updated in proper time)
                    }
                }
            }
        }
    }
}

//This makes the Container View a delegate for the Side Menu View controller, which allows communication between them
extension ContainerViewController: SideMenuViewControllerDelegate {
    func didSelect(sideMenuItem: SideMenuViewController.SideMenuOptions) {
        //This is where we will close the side menu and load the view that we selected
//        print("Changing views") //this is not happening right after a selection
        toggleSideMenu(completion: nil)
        switch sideMenuItem {
        case .timeline:
            //Remove calendar view child
            self.resetToTimeline()
        case .calendar:
            //Add calendar view child
            self.addCalendar()
            
            //This is how we "present" a modal to the user
            //let vc = CalendarViewController()
            //self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        case .darkMode:
            //This will be where we change the colors
            if (darkMode == false) {
                darkMode = true
                mainColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
                secondColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
                print("Dark mode on")
            } else {
                darkMode = false
                mainColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
                secondColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
                print("Dark mode off")
            }
            sideMenuTableView.reloadData()
            timelineTableView.reloadData()
            break
        case .logOut:
            //This will be where we logout
            self.logout()
            break
        }
        
        
        
//THIS IS USEFUL FOR PROPER STAGING OF THE PAGES IN SEQUENCE OF THE PROGRAM. HOWEVER WE WANT TO LOAD THE PAGES IMMEDIATELY EVEN DURING THE ANIMATION, SO INSTEAD OF DOING IT AS A COMPLETION/CALLBACK FUNCTION DONE AFTER THE ANIMATION, WE WILL DO IT ALONG SIDE THE ANIMATION. WE JUST HAVE TO BE CAREFUL WHEN DOING THIS
//        //This is where we will close the side menu and go to the location that we selected
//        toggleSideMenu(completion: { [weak self] in
//            switch sideMenuItem {
//
//            case .timeline:
//                //Remove calendar view child
//                self?.resetToTimeline()
//            case .calendar:
//                //Add calendar view child
//                self?.addCalendar()
//
//                //This is how we "present" a modal to the user
//                //let vc = CalendarViewController()
//                //self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
//            case .darkMode:
//                //This will be where we change the colors
//                break
//            case .logOut:
//                //This will be where we logout
//                break
//            }
//        })
    }
    
    func addCalendar() {
        let vc = calendarVC
        timelineVC.addChild(vc)
        timelineVC.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: timelineVC)
        timelineVC.title = vc.title //Since we are keeping the top bar from the timeline view, we need to modify it to match the bar from the calendar view
    }
    
    func resetToTimeline() {
        calendarVC.view.removeFromSuperview() //seemingly removes the child view aswell?
        calendarVC.didMove(toParent: nil)
        timelineVC.title = "Timeline"
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch let err {
            print(err)
        }
            
        
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "homeNavigationController") as! UINavigationController
            self.present(vc, animated: false, completion: nil)
        }
    }
}
