//
//  AddClassViewController.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/19/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import UIKit
import Firebase

class AddClassViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {

    //Predefined Properties
    var school : School? = nil
    var periodCount : Int? {
        if let periods = school?.MaxStudentCourseLoad {
            return periods
        } else {
            return nil
        }
    }
    
    //IB Outlets
    @IBOutlet var ErrorClass: UILabel!
    @IBOutlet var ClassTitle: UITextField!
    @IBOutlet var RoomNumber: UITextField!
    @IBOutlet var TeacherButton: UIButton!
    @IBOutlet var PeriodButton: UIButton!
    @IBOutlet var Picker: UIPickerView!
    @IBOutlet var TeacherPicker: UIPickerView!
    @IBOutlet var AddClassButton: UIButton!
    @IBOutlet var AddTeacher: UIButton!
    @IBOutlet var TeacherView: UIView!
    
    @IBOutlet var VisualEffectView: UIVisualEffectView!
    
    //Properties
    var currentSelectorItem : currentSelector = .teacher
    var classData : [String : Any] = [:]
    var currentPeriod : Int? = nil
    var currentPeriodRow : Int? {
        if let per = self.currentPeriod {
            return per - 1
        } else {
            return nil
        }
    }
    var currentTeacher : Faculty? = nil
    var currentTeacherRow : Int? = nil
    var effect : UIVisualEffect!
    
    //Temporary Type
    enum currentSelector {
        case teacher, period
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorClass.isHidden = true
        Picker.isHidden = true
        effect = VisualEffectView.effect
        VisualEffectView.effect = nil
        TeacherView.layer.cornerRadius = 5
    }
    
    //Update Function
    func updateUserInfo() {
        if let crsName = ClassTitle.text {
            self.classData["displayName"] = crsName
        }
        if let roomNum = RoomNumber.text {
            self.classData["classroom"] = roomNum
        }
        switch currentSelectorItem {
        case .period:
            if let period = currentPeriod {
                self.classData["period"] = period
            }
        case .teacher:
            if let teacher = currentTeacher {
                self.classData["teacher"] = teacher
            }
        }
        if let schoolId = self.school?.id {
            self.classData["schoolId"] = schoolId
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.Picker {
            switch currentSelectorItem {
            case .teacher:
                if let school = school {
                    if let fac = school.Staff {
                        return fac.count
                    } else {
                        return 1 //error
                    }
                } else {
                    return 1 //error
                }
            case .period:
                if let periods = periodCount {
                    return periods
                } else {
                    return 1
                }
            }
        } else {
            return FacTitle.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.Picker {
            switch currentSelectorItem {
            case .teacher:
                if let school = school {
                    print("OCTOPUS: ")
                    dump(school)
                    if let fac = school.Staff {
                        return fac[row].fullLastName
                    } else {
                        return "No Teachers Available"
                    }
                } else {
                    return "error"
                }
            case .period:
                return "\(row + 1)"
            }
        } else {
            return FacTitle.allValues[row].rawValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.Picker {
            switch currentSelectorItem {
            case .teacher:
                if let fac = school?.Staff {
                    self.TeacherButton.titleLabel?.text = "Teacher: \(fac[row].lastName)"
                    self.currentTeacher = fac[row]
                    self.currentTeacherRow = row
                }
            case .period:
                self.PeriodButton.titleLabel?.text = "Period: \(row + 1)"
                self.currentPeriod = row + 1
            }
        } else {
            currentNewTeacherTitle = FacTitle.allValues[row]
        }
    }
    
    //Animation Functions
    func animateIn() {
        self.view.addSubview(TeacherView)
        TeacherView.center = self.view.center
        
        TeacherView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        TeacherView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.VisualEffectView.effect = self.effect
            self.TeacherView.alpha = 1
            self.TeacherView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.TeacherView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.TeacherView.alpha = 0
            
            self.VisualEffectView.effect = nil
        }) { (success:Bool) in
            self.TeacherView.removeFromSuperview()
        }
    }
    
    //IB Actions
    @IBAction func TitleStart(_ sender: Any) {
        updateUserInfo()
        self.Picker.isHidden = true
    }
    @IBAction func RoomNumStart(_ sender: Any) {
        updateUserInfo()
        self.Picker.isHidden = true
    }
    @IBAction func Title(_ sender: Any) {
        updateUserInfo()
        self.Picker.isHidden = true
    }
    
    @IBAction func RoomNum(_ sender: Any) {
        updateUserInfo()
        self.Picker.isHidden = true
    }
    
    @IBAction func Teacher(_ sender: Any) {
        updateUserInfo()
        self.currentSelectorItem = .teacher
        self.Picker.reloadAllComponents()
        if let teacherRow = self.currentTeacherRow {
            self.Picker.selectRow(teacherRow, inComponent: 0, animated: true)
        } else {
            self.Picker.selectRow(0, inComponent: 0, animated: true)
        }
        self.Picker.isHidden = false
    }
    
    @IBAction func Period(_ sender: Any) {
        updateUserInfo()
        self.currentSelectorItem = .period
        self.Picker.reloadAllComponents()
        if let periodRow = self.currentPeriodRow {
            self.Picker.selectRow(periodRow, inComponent: 0, animated: true)
        } else {
            self.Picker.selectRow(0, inComponent: 0, animated: true)
        }
        self.Picker.isHidden = false
    }
    
    @IBAction func addTeacher(_ sender: Any) {
        animateIn()
        self.ClassTitle.isUserInteractionEnabled = false
        self.RoomNumber.isUserInteractionEnabled = false
        self.TeacherButton.isEnabled = false
        self.PeriodButton.isEnabled = false
        self.AddClassButton.isEnabled = false
        self.Picker.isHidden = true
    }
    
    @IBAction func endAddTeacher(_ sender: Any) {
        updateNewTeacherInfo()
        let result = verifyNewTeacher()
        if result == nil {
            //Good Teacher
            if let id = school?.id {
                let colRef = db.collection("schools/\(id)/faculty")
                
                do {
                    dump(addTeacherData)
                    let teacher = try Faculty(ref: colRef, data: addTeacherData)
                } catch let err as firebaseInterpretationError {
                    print("Error: \(err.localizedDescription)")
                } catch {
                    print("Unkown error")
                }
            } else {
                print("School ID Error")
            }
            animateOut()
            self.ClassTitle.isUserInteractionEnabled = true
            self.RoomNumber.isUserInteractionEnabled = true
            self.TeacherButton.isEnabled = true
            self.PeriodButton.isEnabled = true
            self.AddClassButton.isEnabled = true
        } else {
            let failureAlert = UIAlertController(title: "Unable to Add Teacher", message: result, preferredStyle: .alert)
            failureAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(failureAlert, animated: true)
        }
    }
    
    
    @IBAction func AddClass(_ sender: Any) {
        self.Picker.isHidden = true
        updateUserInfo()
        if let errorMessage = verification() {
            self.ErrorClass.text = errorMessage
            self.ErrorClass.isHidden = false
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: ErrorClass.center.x - 10, y: ErrorClass.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: ErrorClass.center.x + 10, y: ErrorClass.center.y))
            
            self.ErrorClass.layer.add(animation, forKey: "position")
            return
        }
        self.ErrorClass.isHidden = true
        guard let schoolID = self.school?.id else {
            print("Error interpreting School ID")
            return
        }
        let collectionRef = db.collection("schools/\(schoolID)/courseList")
        print("Octopus:")
        dump(self.classData)
        do {
            _ = try Course(ref: collectionRef, data: self.classData)
        } catch let error as firebaseInterpretationError {
            print("Error adding class: \(error)")
        } catch {
            print("Unknown error adding class")
        }
        
        let successAlert = UIAlertController(title: "Your Class Has Been Added", message: "Thank You For Your Contribution!", preferredStyle: .alert)
        successAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.performSegue(withIdentifier: "returnToSignUpChooseClass", sender: self)
        }))
        
        self.present(successAlert, animated: true)
    }
    
    func verification()-> String? {
        var returnStr = ""
        if self.ClassTitle.text == "" || self.ClassTitle.text == nil {
            returnStr.append("Please specify a class title. ")
        }
        if self.currentTeacher == nil {
            returnStr.append("Please select a teacher. ")
        }
        if self.currentPeriod == nil {
            returnStr.append("Please choose a period. ")
        }
        
        if returnStr == "" {
            return nil
        } else {
            return returnStr
        }
    }
    
    //Add Teacher
    var currentNewTeacherTitle : FacTitle? = nil
    var addTeacherData : [String : Any] = [:]
    
    func updateNewTeacherInfo() {
        if let first = teacherFirst.text {
            addTeacherData["firstName"] = first
        }
        if let last = teacherLast.text {
            addTeacherData["lastName"] = last
        }
        if let currentNewTeacherTitle = currentNewTeacherTitle {
            addTeacherData["title"] = currentNewTeacherTitle
        }
    }
    
    func verifyNewTeacher() -> String? {
        var returnStr = ""
        if teacherLast.text == nil || teacherLast.text == "" {
            returnStr.append("Please Specify a Last Name. ")
        }
        if currentNewTeacherTitle == nil {
            returnStr.append("Please select a Title. ")
        }
        if returnStr == "" {
            return nil
        } else {
            return returnStr
        }
    }
    
    //Add Teacher IB Actions and Outlets
    
    @IBOutlet var teacherLast: UITextField!
    @IBOutlet var teacherFirst: UITextField!
    
    @IBAction func firstNameStart(_ sender: Any) {
        updateNewTeacherInfo()
    }
    @IBAction func firstNameEnd(_ sender: Any) {
        updateNewTeacherInfo()
    }
    @IBAction func lastNameStart(_ sender: Any) {
        updateNewTeacherInfo()
    }
    @IBAction func lastNameEnd(_ sender: Any) {
        updateNewTeacherInfo()
    }
    
}







