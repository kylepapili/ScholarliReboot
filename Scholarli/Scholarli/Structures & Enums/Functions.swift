//
//  Functions.swift
//  Scholarli
//
//  Created by Kyle Papili on 7/7/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import Foundation

func verifyNewCourseToSchedule(courseToAdd : Course , schedule: Schedule?) -> Bool {
    guard let sched = schedule else {
        print("No Schedule found")
        return true
    }
    guard let crsLd = sched.courseLoad else {
        print("Unable to find schedule")
        return true
    }
    let periodToCheck = courseToAdd.period
    for currentCourse in crsLd {
        if currentCourse.period == periodToCheck {
            return false
        }
    }
    return true
}
