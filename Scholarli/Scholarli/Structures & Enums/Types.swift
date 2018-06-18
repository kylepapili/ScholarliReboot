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

enum AccountType {
    case student
    case teacher
    case admin
    case parent
    case developer
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
}
