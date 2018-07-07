//
//  ChooseClassesViewController.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/19/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import UIKit


class ChooseClassesViewController: UIViewController , UITableViewDataSource , UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var periods: UILabel!
    @IBOutlet var errors: UILabel!
    @IBOutlet var searchbar: UISearchBar!
    
    var userSchool : School?
    var searchResults : [Course]? = []
    var showAllCourses : Bool = true
    var userSelectedCourses : [Course] = []
    var currentUserSchedule : Schedule?
    let schoolAlert = UIAlertController(title: "Error", message: "Please Select a School.", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schoolAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.errors.isHidden = true
        if let school = self.userSchool {
            self.currentUserSchedule = Schedule(maxCourseCount: school.MaxStudentCourseLoad, courseLoad: [])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showAllCourses {
            if let courses = self.userSchool?.CourseList {
                return courses.count
            } else {
                return 1
            }
        } else {
            guard let data = searchResults else {
                return 0
            }
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showAllCourses {
            
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
                
                guard let crsLd = self.currentUserSchedule?.courseLoad else {
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath)
                    cell.textLabel?.text = "Error Retrieving User Schedule"
                    return cell
                }
                dump(crsLd)
                if crsLd.contains(where: { (crs) -> Bool in
                    if crs.id == courses[indexPath.row].id {
                        return true
                    } else {
                        return false
                    }
                }) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
                
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
        } else {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as? CourseTableViewCell else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath)
                cell.textLabel?.text = "Error Loading Courses"
                return cell
            }
            guard let data = self.searchResults else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath)
                cell.textLabel?.text = "Error Loading Courses"
                return cell
            }
            cell.TeacherName.text = data[indexPath.row].teacher.fullLastName
            cell.CourseTitle.text = data[indexPath.row].displayName
            cell.Period.text = "\(data[indexPath.row].period)"
            
            guard let crsLd = self.currentUserSchedule?.courseLoad else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath)
                cell.textLabel?.text = "Error Retrieving User Schedule"
                return cell
            }
            if crsLd.contains(where: { (crs) -> Bool in
                if crs.id == data[indexPath.row].id {
                    return true
                } else {
                    return false
                }
            }) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       guard let cell = self.tableView.cellForRow(at: indexPath) as? CourseTableViewCell else {
            print("Cell error")
            return
        }
        guard let courses = self.userSchool?.CourseList else {
            print("No courses found")
            self.errors.text = "No courses found"
            self.errors.isHidden = false
            shake(cell: self.errors)
            shake(cell: cell)
            return
        }
        guard let resultCourses = self.searchResults else {
            print("Unable to load search results")
            self.errors.text = "Unable to load search results"
            self.errors.isHidden = false
            shake(cell: self.errors)
            shake(cell: cell)
            return
        }
        guard let userCourses = self.currentUserSchedule?.courseLoad else {
            print("No user schedule found")
            self.errors.text = "No user schedule found"
            self.errors.isHidden = false
            shake(cell: self.errors)
            shake(cell: cell)
            return
        }
        if showAllCourses {
            //Showing All Courses
            if userCourses.contains(where: { (crs) -> Bool in
                if crs.id == courses[indexPath.row].id {
                    return true
                } else {
                    return false
                }
            }) {
                //Remove Course
                let courseToRemove = courses[indexPath.row]
                cell.accessoryType = .none
                let index = userCourses.index { (crs) -> Bool in
                    if crs.id == courseToRemove.id {
                        return true
                    } else {
                        return false
                    }
                }
                if let ind = index {
                    self.currentUserSchedule?.courseLoad?.remove(at: ind)
                }
            } else {
                //Add Course
                guard let sched = self.currentUserSchedule else {
                    print("No user schedule found")
                    self.errors.text = "No user schedule found"
                    self.errors.isHidden = false
                    shake(cell: self.errors)
                    shake(cell: cell)
                    return
                }
                let courseToAdd = courses[indexPath.row]
                let result = verifyNewCourseToSchedule(courseToAdd: courseToAdd, schedule: sched)
                if result {
                    cell.accessoryType = .checkmark
                    self.currentUserSchedule?.courseLoad?.append(courseToAdd)
                } else {
                    cell.accessoryType = .none
                    self.errors.text = "You have already selected a course for period \(courseToAdd.period)"
                    shake(cell: self.errors)
                    shake(cell: cell)
                }
            }
        } else {
            //Showing Search Results
            if userCourses.contains(where: { (crs) -> Bool in
                if crs.id == resultCourses[indexPath.row].id {
                    return true
                } else {
                    return false
                }
            }) {
                //Remove Course
                let courseToRemove = resultCourses[indexPath.row]
                cell.accessoryType = .none
                let index = userCourses.index { (crs) -> Bool in
                    if crs.id == courseToRemove.id {
                        return true
                    } else {
                        return false
                    }
                }
                if let ind = index {
                    self.currentUserSchedule?.courseLoad?.remove(at: ind)
                }
            } else {
                //Add Course
                guard let sched = self.currentUserSchedule else {
                    print("No user schedule found")
                    self.errors.text = "No user schedule found"
                    self.errors.isHidden = false
                    shake(cell: self.errors)
                    shake(cell: cell)
                    return
                }
                let courseToAdd = resultCourses[indexPath.row]
                let result = verifyNewCourseToSchedule(courseToAdd: courseToAdd, schedule: sched)
                if result {
                    cell.accessoryType = .checkmark
                    self.currentUserSchedule?.courseLoad?.append(courseToAdd)
                } else {
                    cell.accessoryType = .none
                    self.errors.text = "You have already selected a course for period \(courseToAdd.period)"
                    shake(cell: self.errors)
                    shake(cell: cell)
                }
            }
        }
        if let sched = self.currentUserSchedule {
            if let cnt = sched.maxCourseCount {
                self.periods.text = periodLabelTextGenerator(schedule: sched, count: cnt)
            }
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
    
    //Search Bar Functions
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.showAllCourses = false
        self.searchResults = []
        
        searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchbar.text = nil
        self.showAllCourses = true
        self.searchResults = []
        self.tableView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchResults = []
        guard let fullData = self.userSchool?.CourseList else {
            print("Error getting full Data")
            return
        }
        let lowerCasedText = searchText.lowercased()
        for course in fullData {
            if course.displayName.lowercased().contains(lowerCasedText) {
                self.searchResults?.append(course)
            } else if course.teacher.fullLastName.lowercased().contains(lowerCasedText) {
                self.searchResults?.append(course)
            } else if String(course.period).lowercased().contains(lowerCasedText) {
                self.searchResults?.append(course)
            }
        }
        self.tableView.reloadData()
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
    func periodLabelTextGenerator(schedule: Schedule, count: Int) -> String {
        guard var courses = schedule.courseLoad else {
            return "\(count) courses selected"
        }
        print(courses)
        var textToReturn = ""
        courses.sort { (crsOne, crsTwo) -> Bool in
            if (crsOne.period < crsTwo.period) {
                return true
            } else {
                return false
            }
        }
        var x = 0
        textToReturn = "Periods Selected: "
        for course in courses {
            if x == courses.count - 1 {
                textToReturn.append("\(course.period)")
            } else {
                textToReturn.append("\(course.period), ")
            }
            x = x + 1
        }
        if textToReturn == "Periods Selected: " {
            return "No Courses Selected"
        } else {
            return textToReturn
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseClassToAddClass" {
            let destinationVC = segue.destination as! AddClassViewController
            destinationVC.school = self.userSchool
            destinationVC.scheduleToReturn = self.currentUserSchedule
        }
        if segue.identifier == "signUpSegueThree" {
            newUserData["schedule"] = self.currentUserSchedule
        }
    }
}
