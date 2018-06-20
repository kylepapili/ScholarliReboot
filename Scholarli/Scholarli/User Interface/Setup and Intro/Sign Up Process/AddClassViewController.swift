//
//  AddClassViewController.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/19/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import UIKit

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
    @IBOutlet var AddClassButton: UIButton!
    
    //Properties
    var currentSelectorItem : currentSelector = .teacher
    var classData : [String : Any] = [:]
    var currentPeriod : Int? = nil
    var currentTeacher : Faculty? = nil
    
    //Temporary Type
    enum currentSelector {
        case teacher, period
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorClass.isHidden = true
        //Picker.isHidden = true
    }
    
    //Update Function
    func updateUserInfo() {
        self.classData["displayName"] = ClassTitle.text
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
        
        if let school = self.school {
            self.classData["school"] = school
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch currentSelectorItem {
        case .teacher:
            if let school = school {
                if let fac = school.Staff {
                    return fac[row].fullLastName
                } else {
                    return "error"
                }
            } else {
                return "error"
            }
        case .period:
            return "\(row + 1)"
        }
    }
    
}
