//
//  Objects.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/17/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import Foundation

struct School {
    //Identification Properties
    let displayName : String
    let id : String
    let type : SchoolType
    let streetAddress : String
    let city : String
    let zipCode : Int
    let state : String
    var address : String {
        return "\(streetAddress) \(city) \(state) \(zipCode)"
    }
    
    //School Data
    var CourseList : [Course]?
    var Staff : [Faculty]?
    let MaxStudentCourseLoad : Int?
    
    //Initializer
    init(displayName : String , id: String, type : SchoolType , streetAddress : String , city : String , zipCode : Int , state : String , MaxStudentCourseLoad : Int?) {
        self.displayName = displayName
        self.id = id
        self.type = type
        self.streetAddress = streetAddress
        self.city = city
        self.zipCode = zipCode
        self.state = state
        if let unwrapped = MaxStudentCourseLoad {
            self.MaxStudentCourseLoad = unwrapped
        } else {
            self.MaxStudentCourseLoad = nil
        }
    }
}

struct Course {
    //Identification Properties
    let displayName : String
    let id : String
    let teacher : Faculty
    let school : School
    let period : Int
    let classroom : Int?
    
    //Initializer
    init(displayName : String , id: String, teacher: Faculty, school: School, period: Int, classroom: Int?) {
        self.displayName = displayName
        self.id = id
        self.teacher = teacher
        self.school = school
        self.period = period
        if let unwrapped = classroom {
            self.classroom = unwrapped
        } else {
            self.classroom = nil
        }
    }
}

struct Faculty {
    let account : Account?
    //Identification Properties
    let lastName : String
    let firstName : String?
    let title : Title
    var fullLastName : String {
        return "\(title) \(lastName)"
    }
    var schedule : Schedule?
    
    //Initializer
    init(account : Account?, lastName : String , firstName : String? , title : Title , schedule : Schedule?) {
        if let account = account {
            self.account = account
        } else {
            self.account = nil
        }
        self.lastName = lastName
        if let firstName = firstName {
            self.firstName = firstName
        } else {
            self.firstName = nil
        }
        self.title = title
        if let sched = schedule {
            self.schedule = sched
        } else {
            self.schedule = nil
        }
    }
}

struct Schedule {
    let maxCourseCount : Int
    let CourseLoad : [Int : Course?]
    
    init(maxCourseCount : Int , CourseLoad : [Int : Course?]) {
        self.maxCourseCount = maxCourseCount
        self.CourseLoad = CourseLoad
    }
}

struct Account {
    //Identification Properties
    let id: String
    let firstName : String
    let lastName : String
    var username : String
    var phoneNumber : Int
    var school : School
    
    //Preferences
    var blockedUsers : [Account]?
    
    //Technical Information
    var pushToken : String?
    var notificationReady : Bool
    var type : AccountType
    var blockedBy : [Account]?
    var KarmaLevel : Int = 0
    
    //Initializer
    init(id: String , firstName : String , lastName : String , username : String , phoneNumber : Int, school : School , blockedUsers : [Account]? , pushToken : String? , notificationReady : Bool , type : AccountType , blockedBy : [Account]?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.phoneNumber = phoneNumber
        self.school = school
        self.blockedUsers = blockedUsers
        self.pushToken = pushToken
        self.notificationReady = notificationReady
        self.type = type
        self.blockedBy = blockedBy
        self.KarmaLevel = 0
    }
}

struct Student {
    //Identification Properties
    let account : Account
    var schedule : Schedule?
    var doNotDisturb : [Course]?
    var agenda : Agenda
    
    //Privacy Settings
    var accountPrivacy : PrivacyPolicies = .classMates
    
    //Initializer
    init(account : Account , schedule : Schedule? , doNotDisturb : [Course]? , agenda : Agenda , accountPrivacy : PrivacyPolicies) {
        self.account = account
        self.schedule = schedule
        self.doNotDisturb = doNotDisturb
        self.agenda = agenda
        self.accountPrivacy = accountPrivacy
    }
}

struct Agenda {
    var assignments : [Assignment]
    init(assignments : [Assignment]) {
        self.assignments = assignments
    }
}

struct Assignment {
    let id : String
    var title : String
    var course : Course?
    var type : AssignmentType
    var dueDate : Date?
    var description : String
    var complete : Bool = false
    
    init(id : String , title : String, course : Course? , type : AssignmentType , dueDate : Date? , description : String , complete : Bool) {
        self.id = id
        self.title = title
        self.course = course
        self.type = type
        self.dueDate = dueDate
        self.description = description
        self.complete = complete
    }
}

























