//
//  Objects.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/17/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import Foundation
import Firebase

let db = Firestore.firestore()


struct School {
    //Identification Properties
    let displayName : String
    let id : String
    let type : SchoolType
    let streetAddress : String
    let city : String
    let zipCode : String
    let state : String
    var address : String {
        return "\(streetAddress) \(city) \(state) \(zipCode)"
    }
    
    //School Data
    var CourseList : [Course]?
    var Staff : [Faculty]?
    let MaxStudentCourseLoad : Int?
    
    var data : [String : Any] {
        var tempDict : [String : Any] = ["displayName" : self.displayName,
                                         "id" : self.id,
                                         "type" : self.type.rawValue,
                                         "streetAddress" : self.streetAddress,
                                         "city" : self.city,
                                         "zipCode" : self.zipCode,
                                         "state" : self.state]
        
        if let courses = self.CourseList {
            var tinyArray : [[String : Any]] = [[:]]
            for course in courses {
                tinyArray.append(course.data)
            }
            tempDict["courseList"] = tinyArray
        }
        
        if let staff = self.Staff {
            var tinyArray : [[String : Any]] = [[:]]
            for person in staff {
                tinyArray.append(person.data)
            }
            tempDict["staff"] = tinyArray
        }
        if let maxstdcrsld = self.MaxStudentCourseLoad {
            tempDict["maxStudentCourseLoad"] = maxstdcrsld
        }
        
        return tempDict
    }
    
    //Functions
    func getFaculty(completion: @escaping ([Faculty]) -> Void) {
        let schoolRef = db.collection("schools/\(self.id)/faculty")
        schoolRef.getDocuments { (snapshot, err) in
            if let err = err {
                print("Error fetching faculty: \(err)")
                return
            } else {
                do {
                    var facList : [Faculty] = []
                    if let docs = snapshot?.documents {
                        for document in docs {
                            let fac = try Faculty(data: document.data())
                            facList.append(fac)
                        }
                        completion(facList)
                    }
                }
                catch {
                    print("Error in getting faculty member")
                    return
                }
            }
        }
    }
//    //Functions
//    func getSchools(completion: @escaping ([School]) -> Void) {
//        schoolQuery { (dataArray) in
//            var schoolArray : [School] = []
//            for data in dataArray {
//                if var tempSchool = try? School(data: data) {
//                    let facultyColRef : CollectionReference = db.collection("schools/\(tempSchool.id)/faculty")
//                    self.subCollectionRetrievalForSchool(ref: facultyColRef, completion: { (staff) in
//                        tempSchool.Staff = staff
//                        schoolArray.append(tempSchool)
//                    })
//                }
//            }
//            completion(schoolArray)
//        }
//    }
//
//    func schoolQuery(completion: @escaping ([[String : Any]]) -> Void) {
//        let schoolsRef = db.collection("schools")
//        schoolsRef.getDocuments { (querySnapshot, err) in
//            if let err = err {
//                //Error
//                print("error: \(err)")
//            } else {
//                var returnValue : [[String : Any]] = [[:]]
//                for document in (querySnapshot?.documents)! {
//                    returnValue.append(document.data())
//                }
//                completion(returnValue)
//            }
//        }
//    }
//
//    func subCollectionRetrievalForSchool(ref : CollectionReference, completion: @escaping ([Faculty]) -> Void ) {
//        ref.getDocuments { (snapshot, err) in
//            if let err = err {
//                print("Error: \(err)") // error
//            } else {
//                if let snap = snapshot {
//                    var staffing : [Faculty] = []
//                    for document in snap.documents {
//                        do {
//                            try staffing.append(Faculty(data: document.data()))
//                        }
//                        catch firebaseInterpretationError.invalidKeys(let err) {
//                            print("Invalid Keys: \(err)")
//                        }
//                        catch firebaseInterpretationError.invalidValue(let err) {
//                            print("Invalid Value \(err)")
//                        }
//                        catch {
//                            print("Unexpected error")
//                        }
//                    }
//                    completion(staffing)
//                }
//            }
//        }
//    }
//
//    func singleSchoolQuery(ref : DocumentReference, completion : @escaping (School) -> Void) {
//        ref.getDocument { (snapshot, err) in
//            if let err = err {
//                //Eerror
//                print("error: \(err)")
//            } else {
//                if let finalData = snapshot?.data() {
//                    do {
//                        let tempSkewl = try School(data: finalData)
//                        completion(tempSkewl)
//                    } catch firebaseInterpretationError.invalidKeys(let error){
//                        print("INVALID KEY ERROR: \(error)")
//                    } catch {
//                        print("Unexpected Error")
//                    }
//                }
//            }
//        }
//    }
    
    //Initializers
    
    //With DB Integration
    init(ref : CollectionReference, displayName : String , type : SchoolType , streetAddress : String , city : String , zipCode : String , state : String , MaxStudentCourseLoad : Int?) {
        self.displayName = displayName
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
        let docRef : DocumentReference = ref.document()
        self.id = docRef.documentID
        
        docRef.setData(self.data)
    }
    
    //Without DB Integration
    init(displayName : String , id: String, type : SchoolType , streetAddress : String , city : String , zipCode : String , state : String , MaxStudentCourseLoad : Int?) {
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
    
    init(data: [String : Any]) throws {
        guard let displayName = data["displayName"] as? String else {
            throw firebaseInterpretationError.invalidKeys("displayName")
        }
        guard let id = data["id"] as? String else {
            throw firebaseInterpretationError.invalidKeys("id")
        }
        guard let typeStr = data["type"] as? String else {
            throw firebaseInterpretationError.invalidKeys("type")
        }
        guard let type : SchoolType = SchoolType(s: typeStr) else {
            throw stringToTypeError.invalidString(typeStr)
        }
        guard let streetAddress = data["streetAddress"] as? String else {
            throw firebaseInterpretationError.invalidKeys("streetAddress")
        }
        guard let city = data["city"] as? String else {
            throw firebaseInterpretationError.invalidKeys("city")
        }
        guard let zipCode = data["zipCode"] as? String else {
            throw firebaseInterpretationError.invalidKeys("zipCode")
        }
        guard let state = data["state"] as? String else {
            throw firebaseInterpretationError.invalidKeys("state")
        }
        guard let maxStudentCourseLoad = data["maxStudentCourseLoad"] as? Int else {
            throw firebaseInterpretationError.invalidKeys("maxStudentCourseLoad")
        }
        
        self.init(displayName: displayName, id: id, type: type, streetAddress: streetAddress, city: city, zipCode: zipCode, state: state, MaxStudentCourseLoad: maxStudentCourseLoad)
        
    }
}

struct Course {
    //Identification Properties
    let displayName : String
    let id : String
    let teacher : Faculty
    let schoolId : String
    let period : Int
    let classroom : String?
    
    var data : [String : Any] {
        var tempDict : [String : Any] = [:]
        tempDict = ["displayName" : self.displayName, "id" : self.id, "teacher" : self.teacher.data, "schoolId" : self.schoolId, "period" : self.period]
        if let classroom = self.classroom {
            tempDict["classroom"] = classroom
        }
        return tempDict
    }
    
    //Initializers
    init(ref: CollectionReference, data: [String : Any]) throws {
        guard let displayName = data["displayName"] as? String else {
            throw firebaseInterpretationError.invalidKeys("displayName")
        }
        guard let teacher = data["teacher"] as? Faculty else {
            throw firebaseInterpretationError.invalidKeys("teacher")
        }
        guard let schoolId = data["schoolId"] as? String else {
            throw firebaseInterpretationError.invalidKeys("schoolId")
        }
        guard let period = data["period"] as? Int else {
            throw firebaseInterpretationError.invalidKeys("period")
        }
        guard let classroom = data["classroom"] as? String? else {
            throw firebaseInterpretationError.invalidKeys("classroom")
        }
        
        self.init(ref: ref, displayname: displayName, teacher: teacher, schoolId: schoolId, period: period, classroom: classroom)
    }
    
    //without ID Specified
    init(ref: CollectionReference, displayname : String , teacher: Faculty, schoolId: String, period: Int, classroom: String?) {
        self.displayName = displayname
        self.teacher = teacher
        self.schoolId = schoolId
        self.period = period
        if let unwrapped = classroom {
            self.classroom = unwrapped
        } else {
            self.classroom = nil
        }
        let docRef : DocumentReference = ref.document()
        self.id = docRef.documentID
        
        docRef.setData(self.data)
    }
    
    //With ID specified
    init(displayName : String , id: String, teacher: Faculty, schoolId: String, period: Int, classroom: String?) {
        self.displayName = displayName
        self.id = id
        self.teacher = teacher
        self.schoolId = schoolId
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
    let id : String
    let lastName : String
    let firstName : String?
    let title : FacTitle
    var fullLastName : String {
        return "\(title) \(lastName)"
    }
    var schedule : Schedule?
    
    var data : [String : Any] {
        var tempDict : [String : Any] = ["id" : self.id ,
         "lastName" : self.lastName,
         "title" : self.title.rawValue]
        if let acct = self.account {
            tempDict["account"] = acct.data
        }
        if let firstN = self.firstName {
            tempDict["firstName"] = firstN
        }
        if let sched = self.schedule {
            tempDict["schedule"] = sched.data
        }
        return tempDict
    }
    
    //Initializer
    
    //From Data
    init(data: [String : Any]) throws {
        if let acct = data["account"] as? Account? {
            self.account = acct
        } else {
            self.account = nil
        }
        if let id = data["id"] as? String {
            self.id = id
        } else {
            throw firebaseInterpretationError.invalidKeys("id")
        }
        if let lastName = data["lastName"] as? String {
            self.lastName = lastName
        } else {
            throw firebaseInterpretationError.invalidKeys("lastName")
        }
        if let firstName = data["firstName"] as? String? {
            self.firstName = firstName
        } else {
            throw firebaseInterpretationError.invalidKeys("firstName")
        }
        if let titleStr = data["title"] as? String {
            if let title = FacTitle(rawValue: titleStr) {
                self.title = title
            } else {
                throw stringToTypeError.invalidString(titleStr)
            }
        } else {
            throw firebaseInterpretationError.invalidKeys("title")
        }
        if let schedule = data["schedule"] as? Schedule? {
            self.schedule = schedule
        } else {
            self.schedule = nil
        }
    }
    
    //With database integration
    init(ref : CollectionReference, data: [String : Any]) throws {
        if let acct = data["account"] as? Account? {
            self.account = acct
        } else {
            self.account = nil
        }
        if let lastName = data["lastName"] as? String {
            self.lastName = lastName
        } else {
            throw firebaseInterpretationError.invalidKeys("lastName")
        }
        if let firstName = data["firstName"] as? String? {
            self.firstName = firstName
        } else {
            throw firebaseInterpretationError.invalidKeys("firstName")
        }
        if let title = data["title"] as? FacTitle {
            self.title = title
        } else {
            throw firebaseInterpretationError.invalidKeys("title")
        }
        if let schedule = data["schedule"] as? Schedule? {
            self.schedule = schedule
        } else {
            self.schedule = nil
        }
        
        let docRef : DocumentReference = ref.document()
        self.id = docRef.documentID
        docRef.setData(self.data)
    }
    
    init(ref : CollectionReference, lastName : String , firstName : String? , title : FacTitle , schedule : Schedule?, account: Account?) {
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
        let docRef : DocumentReference = ref.document()
        self.id = docRef.documentID
        
        docRef.setData(self.data)
    }
    
    //Without database integration
    init(account : Account?, lastName : String , firstName : String? , title : FacTitle , schedule : Schedule?, id : String) {
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
        self.id = id
    }
}

struct Schedule {
    let maxCourseCount : Int
    let courseLoad : [Course]?
    let id : String
    var data : [String : Any] {
        var tempDict : [String : Any] = ["maxCourseCount" : self.maxCourseCount]
        
        if let crsLd = self.courseLoad {
            var tinyArray : [[String : Any]] = [[:]]
            for crs in crsLd {
                tinyArray.append(crs.data)
            }
            tempDict["courseLoad"] = tinyArray
            
        }
        return tempDict
    }
    //Initializers
    
    //With DB Integration
    init(ref: CollectionReference, maxCourseCount : Int , courseLoad : [Course]?) {
        self.maxCourseCount = maxCourseCount
        self.courseLoad = courseLoad
        let docRef : DocumentReference = ref.document()
        self.id = docRef.documentID
        
        docRef.setData(self.data)
    }
    //Without DB Integration
    init(maxCourseCount : Int , courseLoad : [Course]?, id : String) {
        self.maxCourseCount = maxCourseCount
        self.courseLoad = courseLoad
        self.id = id
    }
}

struct Account {
    //Identification Properties
    let id: String
    let firstName : String
    let lastName : String
    var username : String
    var phoneNumber : Int
    var schoolId : String
    
    //Preferences
    var blockedUsers : [Account]?
    
    //Technical Information
    var pushToken : String?
    var notificationReady : Bool
    var type : AccountType
    var blockedBy : [Account]?
    var KarmaLevel : Int = 0
    
    var data : [String : Any] {
        var tempDict : [String : Any] = ["id" : self.id,
                                         "firstName" : self.firstName,
                                         "lastName" : self.lastName,
                                         "username" : self.username,
                                         "phoneNumber" : self.phoneNumber,
                                         "notificationReady" : self.notificationReady,
                                         "type" : self.type.rawValue,
                                         "karmaLevel" : self.KarmaLevel,
                                         "schoolId" : self.schoolId]
        if let blockedUsers = self.blockedUsers {
            var tinyArray : [[String : Any]] = [[:]]
            for user in blockedUsers {
                tinyArray.append(user.data)
            }
            tempDict["blockedUsers"] = tinyArray
        }
        if let pushToken = self.pushToken {
            tempDict["pushToken"] = pushToken
        }
        if let blockedBy = self.blockedBy {
            var tinyArray : [[String : Any]] = [[:]]
            for user in blockedBy {
                tinyArray.append(user.data)
            }
            tempDict["blockedBy"] = tinyArray
        }
        
        return tempDict
    }
    
    //Initializers
    
    //With DB Integration
    init(ref: CollectionReference, firstName : String , lastName : String , username : String , phoneNumber : Int, schoolId : String , blockedUsers : [Account]? , pushToken : String? , notificationReady : Bool , type : AccountType , blockedBy : [Account]?) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.phoneNumber = phoneNumber
        self.schoolId = schoolId
        self.blockedUsers = blockedUsers
        self.pushToken = pushToken
        self.notificationReady = notificationReady
        self.type = type
        self.blockedBy = blockedBy
        self.KarmaLevel = 0
        
        let docRef : DocumentReference = ref.document()
        self.id = docRef.documentID
        
        docRef.setData(self.data)
    }
    
    //Without DB Integration
    init(id: String , firstName : String , lastName : String , username : String , phoneNumber : Int, schoolId : String , blockedUsers : [Account]? , pushToken : String? , notificationReady : Bool , type : AccountType , blockedBy : [Account]?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.phoneNumber = phoneNumber
        self.schoolId = schoolId
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
    let id : String
    var schedule : Schedule?
    var doNotDisturb : [Course]?
    var agenda : Agenda
    
    //Privacy Settings
    var accountPrivacy : PrivacyPolicies = .classMates
    
    var data : [String : Any] {
        var tempDict : [String : Any] = ["account" : self.account.data,
                                         "agenda" : self.agenda.data,
                                         "accountPrivacy" : self.accountPrivacy.rawValue]
        if let sched = self.schedule {
            tempDict["schedule"] = sched.data
        }
        if let doNotDisturb = self.doNotDisturb {
            var tinyArray : [[String : Any]] = [[:]]
            for singleCourse in doNotDisturb {
                tinyArray.append(singleCourse.data)
            }
            tempDict["doNotDisturb"] = tinyArray
        }
        
        return tempDict
    }
    
    //Initializers
    
    //With DB Integration
    init(ref : CollectionReference, account : Account , schedule : Schedule? , doNotDisturb : [Course]? , agenda : Agenda , accountPrivacy : PrivacyPolicies) {
        self.account = account
        self.schedule = schedule
        self.doNotDisturb = doNotDisturb
        self.agenda = agenda
        self.accountPrivacy = accountPrivacy
        
        let docRef : DocumentReference = ref.document()
        self.id = docRef.documentID
        
        docRef.setData(self.data)
    }
    
    
    //Without DB Integration
    init(account : Account , schedule : Schedule? , doNotDisturb : [Course]? , agenda : Agenda , accountPrivacy : PrivacyPolicies, id : String) {
        self.account = account
        self.schedule = schedule
        self.doNotDisturb = doNotDisturb
        self.agenda = agenda
        self.accountPrivacy = accountPrivacy
        self.id = id
    }
}

struct Agenda {
    var assignments : [Assignment]
    var data : [String : Any] {
        return ["assignments" : self.assignments]
    }
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

























