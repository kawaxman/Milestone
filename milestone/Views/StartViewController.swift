//
//  StartViewController.swift
//  milestone
//
//  Created by Kent Waxman on 11/9/21.
//

import UIKit
import SwiftUI


class StartViewController : UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "startToLogin", sender: self)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "startToSignUp", sender: self)
    }
    
}
