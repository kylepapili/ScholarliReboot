//
//  SecurityViewController.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/18/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import UIKit

class SecurityViewController: UIViewController {
    //PageVC Reference
    var pageVC : SignUpPageViewController?
    
    //Outlets
    
    @IBOutlet var Password: UITextField!
    @IBOutlet var ConfirmPassword: UITextField!
    @IBOutlet var ErrorLabel: UILabel!
    
    func updateAccountInfo() {
        self.pageVC?.newUser?["password"] = Password.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorLabel.isHidden = true
    }
    
    func checkForConfirmation() {
        if(Password.text == ConfirmPassword.text) {
            ErrorLabel.text = ""
            ErrorLabel.isHidden = true
            updateAccountInfo()
        } else {
            ErrorLabel.text = "Please Make Sure The Passwords Match"
            ErrorLabel.isHidden = false
        }
    }
    
    @IBAction func PasswordDoneEditing(_ sender: Any) {
        checkForConfirmation()
    }
    
    @IBAction func ConfirmPasswordDoneEditing(_ sender: Any) {
        checkForConfirmation()
    }
    
}
