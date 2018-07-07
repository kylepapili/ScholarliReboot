//
//  UserInfoViewController.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/18/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import UIKit

var newUserData : [String : Any] = [:]
class UserInfoViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {
    
    //Properties
    var currentAccountType : AccountType? = nil
    
    //Outlets
    @IBOutlet var FirstName: UITextField!
    @IBOutlet var LastName: UITextField!
    @IBOutlet var Username: UITextField!
    @IBOutlet var PhoneNumber: UITextField!
    @IBOutlet var AccountTypeButton: UIButton!
    @IBOutlet var AccountTypeSelector: UIPickerView!
    @IBOutlet var error: UILabel!
    
    func updateAccountInfo() {
        newUserData["firstName"] = FirstName.text
        newUserData["lastName"] = LastName.text
        newUserData["userName"] = Username.text
        newUserData["phoneNumber"] = PhoneNumber.text
        newUserData["accountType"] = currentAccountType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.error.isHidden = true
        AccountTypeSelector.isHidden = true
    }
    
    func newPvc(viewController : String) -> UIPageViewController {
        return UIStoryboard(name: "Main", bundle : nil).instantiateViewController(withIdentifier: viewController) as! UIPageViewController
    }
    
    @IBAction func SelectAccountType(_ sender: Any) {
        AccountTypeSelector.isHidden = false
        self.currentAccountType = .student
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUpSegueOne" {
            //Error Check and update
            updateAccountInfo()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (AccountType.count - 2)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return AccountType.array[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch AccountType.array[row] {
        case "Student":
            self.currentAccountType = AccountType.student
        case "Teacher":
            self.currentAccountType = AccountType.teacher
        case "Parent":
            self.currentAccountType = AccountType.parent
        default:
            self.currentAccountType = nil
        }
        updateAccountInfo()
    }
    
    func verify(completion: @escaping (String) -> Void) {
        updateAccountInfo()
        var stringToReturn : String = ""
        if self.Username.text == "" || self.Username.text == nil {
            stringToReturn.append("Must specify a username. ")
            completion(stringToReturn)
            return
        } else {
            verifyUsername(username: self.Username.text!) { (result) in
                if let finalResult = result {
                    if !finalResult {
                        //Ussername taken
                        stringToReturn.append("Username is already taken. ")
                    }
                    if self.FirstName.text == "" || self.FirstName.text == nil {
                        stringToReturn.append("Must specify a first name. ")
                    }
                    if self.LastName.text == "" || self.LastName.text == nil {
                        stringToReturn.append("Must specify a last name. ")
                    }
                    if self.PhoneNumber.text == nil || self.PhoneNumber.text == "" {
                        stringToReturn.append("Must provide a phone number. ")
                    }
                    if self.currentAccountType == nil {
                        stringToReturn.append("Must select an account type. ")
                    }
                    completion(stringToReturn)
                }
            }
        }
        
    }
    
    @IBAction func ContinueAction(_ sender: Any) {
        verify { (errorMessage) in
            print(errorMessage)
            if !(errorMessage == "") {
                self.error.text = errorMessage
                self.error.isHidden = false
                self.shake(cell: self.error)
                return
            }
            self.performSegue(withIdentifier: "signUpSegueOne", sender: self)
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





