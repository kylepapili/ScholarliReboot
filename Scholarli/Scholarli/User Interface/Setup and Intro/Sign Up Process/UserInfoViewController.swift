//
//  UserInfoViewController.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/18/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {
    //PageVC Reference
    var pageVC : SignUpPageViewController?
    
    //Properties
    var currentAccountType : AccountType? = nil
    
    //Outlets
    @IBOutlet var FirstName: UITextField!
    @IBOutlet var LastName: UITextField!
    @IBOutlet var Username: UITextField!
    @IBOutlet var PhoneNumber: UITextField!
    @IBOutlet var AccountTypeButton: UIButton!
    @IBOutlet var AccountTypeSelector: UIPickerView!
    
    func updateAccountInfo() {
        self.pageVC?.newUser? = ["firstName" : FirstName.text,
                                 "lastName" : LastName.text,
                                 "userName" : Username.text,
                                 "phoneNumber" : PhoneNumber.text,
                                 "accountType" : currentAccountType]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AccountTypeSelector.isHidden = true
        self.pageVC = newPvc(viewController: "SignUpPageVc") as? SignUpPageViewController
    }
    
    func newPvc(viewController : String) -> UIPageViewController {
        return UIStoryboard(name: "Main", bundle : nil).instantiateViewController(withIdentifier: viewController) as! UIPageViewController
    }
    
    @IBAction func SelectAccountType(_ sender: Any) {
        AccountTypeSelector.isHidden = false
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
}
