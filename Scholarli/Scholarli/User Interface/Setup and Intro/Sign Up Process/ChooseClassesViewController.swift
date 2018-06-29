//
//  ChooseClassesViewController.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/19/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import UIKit

class ChooseClassesViewController: UIViewController {

    var pageVC : SignUpPageViewController?
    var userSchool : School? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func addClass(_ sender: Any) {
        if var school = newUserData["school"] as? School{
            school.getFaculty { (facList) in
                school.Staff = facList
                self.userSchool = school
                self.performSegue(withIdentifier: "chooseClassToAddClass", sender: self)
            }
        } else {
            print("School Undefined")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseClassToAddClass" {
            let destinationVC = segue.destination as! AddClassViewController
            destinationVC.school = self.userSchool
        }
    }
}
