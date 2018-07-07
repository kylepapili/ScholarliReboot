//
//  SecurityViewController.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/18/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import UIKit

class SecurityViewController: UIViewController {
    
    //Outlets
    
    @IBOutlet var Password: UITextField!
    @IBOutlet var ConfirmPassword: UITextField!
    @IBOutlet var ErrorLabel: UILabel!
    
    func updateAccountInfo() {
        newUserData["password"] = Password.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorLabel.isHidden = true    }
    
    func newPvc(viewController : String) -> UIPageViewController {
        return UIStoryboard(name: "Main", bundle : nil).instantiateViewController(withIdentifier: viewController) as! UIPageViewController
    }
    
    func checkForConfirmation() -> Bool {
        if(Password.text == ConfirmPassword.text) {
            ErrorLabel.text = ""
            ErrorLabel.isHidden = true
            updateAccountInfo()
            return true
        } else {
            ErrorLabel.text = "Please Make Sure The Passwords Match"
            ErrorLabel.isHidden = false
            return false
        }
    }
    
    @IBAction func PasswordDoneEditing(_ sender: Any) {
        checkForConfirmation()
    }
    
    @IBAction func ConfirmPasswordDoneEditing(_ sender: Any) {
        checkForConfirmation()
    }
    @IBAction func Continue(_ sender: Any) {
        if checkForConfirmation() {
            self.performSegue(withIdentifier: "signUpSegueTwo", sender: self)
        } else {
            shake(cell: self.ErrorLabel)
            return
        }
    }
    func shake(cell: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: cell.center.x - 10, y: cell.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: cell.center.x + 10, y: cell.center.y))
        cell.layer.add(animation, forKey: "position")
    }
    
}
