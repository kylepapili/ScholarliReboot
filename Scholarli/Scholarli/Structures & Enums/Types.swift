//
//  Types.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/17/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import Foundation


enum PrivacyPolicies {
    case totalPrivacy , classMates
}

enum AssignmentType {
    case homework, lab, study, quiz, test, reminder, essay, project
}

enum AccountType : String{
    case student = "Student"
    case teacher = "Teacher"
    case parent = "Parent"
    case admin = "Administrator"
    case developer = "Developer"
    
    static var count: Int { return AccountType.developer.hashValue + 1}
    static var array : [String] {
        return ["Student" , "Teacher" , "Parent" , "Administrator" , "Developer"]
    }
    
    init?(s: String) {
        switch s {
        case "Student":
            self = .student
        case "Teacher":
            self = .teacher
        case "Parent":
            self = .parent
        case "Administrator" :
            self = .admin
        case "Developer" :
            self = . developer
        default:
            return nil
        }
    }
}

enum Title {
    case Mr
    case Mrs
    case Ms
    case Dr
    case Sr
    case Sra
    case Srta
    case Prf
}

enum SchoolType {
    case Public
    case Private
    case Trade
    
    init?(s: String) {
        switch s {
        case "Public":
            self = .Public
        case "Private":
            self = .Private
        case "Trade":
            self = .Trade
        default:
            return nil
        }
    }
}
