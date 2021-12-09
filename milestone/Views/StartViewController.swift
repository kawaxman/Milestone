//
//  StartViewController.swift
//  milestone
//
//  Created by Kent Waxman on 11/9/21.
//

import UIKit
import SwiftUI

//MARK: - SINGLETON EXAMPLE
class StartViewController : UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //BUTTON UI
        loginButton.backgroundColor = .clear
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.white.cgColor
        
        signUpButton.backgroundColor = .clear
        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.borderWidth = 2
        signUpButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "startToLogin", sender: self)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "startToSignUp", sender: self)
    }
    
}
