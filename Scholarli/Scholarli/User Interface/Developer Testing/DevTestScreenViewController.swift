//
//  DevTestScreenViewController.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/19/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import UIKit
import Firebase

class DevTestScreenViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func button(_ sender: Any) {
        let db = Firestore.firestore()
        
//        let testSchool = School(ref: schoolRef, displayName: "Morristown High School", type: .Public, streetAddress: "104 W Main St.", city: "Morristown", zipCode: "07869", state: "NJ", MaxStudentCourseLoad: 8)
//
//        let testAccount = Account(ref: accountRef, firstName: "Devon", lastName: "Kappel", username: "dkappel", phoneNumber: 9088794184, school: testSchool, blockedUsers: nil, pushToken: nil, notificationReady: false, type: .teacher, blockedBy: nil)
//
//        let testTeacher = Faculty(ref: facultyRef, lastName: "Kappel", firstName: "Devon", title: .Mr, schedule: nil, account: testAccount)
        
    }
    
}
