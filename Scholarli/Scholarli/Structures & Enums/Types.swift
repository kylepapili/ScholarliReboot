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

enum FacTitle : String {
    case Mr = "Mr."
    case Mrs = "Mrs."
    case Ms = "Ms."
    case Dr = "Dr."
    case Sr = "Sr."
    case Sra = "Sra."
    case Srta = "Srta."
    case Prf = "Prf"
    
    static var count: Int {
        return FacTitle.Prf.hashValue + 1
    }
    static let allValues = [Mr, Mrs, Ms, Dr, Sr, Sra, Srta, Prf]
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
