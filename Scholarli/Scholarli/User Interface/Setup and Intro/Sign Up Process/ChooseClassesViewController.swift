//
//  ChooseClassesViewController.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/19/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import UIKit

class ChooseClassesViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    var pageVC : SignUpPageViewController?
    var userSchool : School? = nil
    let schoolAlert = UIAlertController(title: "Error", message: "Please Select a School.", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VIEW DID FINALLY LOAD******")
        dump(self.userSchool)
        schoolAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        if let school = self.userSchool {
            school.getCourseList { (crsList) in
                print("Printing the courselist")
                dump(crsList)
                self.userSchool?.CourseList = crsList
                self.tableView.reloadData()
            }
        } else {
            print("School is nil")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let courses = self.userSchool?.CourseList {
            return courses.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let courses = self.userSchool?.CourseList {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as? CourseTableViewCell else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath)
                cell.textLabel?.text = "Error Loading Courses"
                return cell
            }
            cell.CourseTitle.text = courses[indexPath.row].displayName
            cell.TeacherName.text = courses[indexPath.row].teacher.fullLastName
            cell.Period.text = "\(courses[indexPath.row].period)"
            cell.CourseTitle.isHidden = false
            cell.TeacherName.isHidden = false
            cell.Period.isHidden = false
            return cell
        } else {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as? CourseTableViewCell else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath)
                cell.textLabel?.text = "Error Loading Courses"
                return cell
            }
            cell.CourseTitle?.text = "Please Select a School"
            cell.TeacherName.isHidden = true
            cell.Period.isHidden = true
            return cell
        }
    }
    
    
    @IBAction func addClass(_ sender: Any) {
        if var school = newUserData["school"] as? School{
            school.getFaculty { (facList) in
                school.Staff = facList
                self.userSchool = school
                self.performSegue(withIdentifier: "chooseClassToAddClass", sender: self)
            }
        } else {
            self.present(schoolAlert, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseClassToAddClass" {
            let destinationVC = segue.destination as! AddClassViewController
            destinationVC.school = self.userSchool
        }
    }
}
