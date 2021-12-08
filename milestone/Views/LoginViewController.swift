//
//  LoginViewController.swift
//  milestone
//
//  Created by Kent Waxman on 11/9/21.
//

import UIKit
import FirebaseAuth
import SwiftUI


class LoginViewController: UIViewController {
    
    //OUTLETS
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.tintColor = .systemPurple
        backBar.leftBarButtonItem?.tintColor = .systemPurple
        backBar.backBarButtonItem?.tintColor = .systemPurple //NOT WORKING???
    }
    
    @IBAction func loginAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
           if error == nil {
             self.performSegue(withIdentifier: "loginToTimeline", sender: self)
            } else {
             let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
             let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            
              alertController.addAction(defaultAction)
              self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
