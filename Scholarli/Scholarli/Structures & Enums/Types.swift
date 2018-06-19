//
//  Types.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/17/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import Foundation


enum PrivacyPolicies : Int {
    case totalPrivacy = 1 , classMates = 2
}

enum AssignmentType {
    case homework, lab, study, quiz, test, reminder, essay, project
}

enum AccountType : String {
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

enum Title : Int{
    case Mr = 1
    case Mrs = 2
    case Ms = 3
    case Dr = 4
    case Sr = 5
    case Sra = 6
    case Srta = 7
    case Prf = 8
}

enum SchoolType : Int {
    case Public = 1
    case Private = 2
    case Trade = 3
    
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
