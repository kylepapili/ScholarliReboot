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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseClassToAddClass" {
            let destinationVC = segue.destination as! AddClassViewController
            if let school = newUserData["school"] as? School {
                destinationVC.school = school
            }
        }
    }
}
