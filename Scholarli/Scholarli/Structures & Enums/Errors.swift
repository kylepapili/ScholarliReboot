//
//  Errors.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/18/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import Foundation

enum firebaseInterpretationError : Error {
    case invalidKeys(String)
    case invalidValue(String)
    case queryFailed
}

enum stringToTypeError : Error {
    case invalidString(String)
}
