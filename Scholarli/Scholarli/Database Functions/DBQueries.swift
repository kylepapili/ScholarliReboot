//
//  DBQueries.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/27/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import Foundation
import Firebase

func verifyUsername(username: String, completion: @escaping (Bool?) -> Void) {
    let userRef = db.collection("accounts")
    userRef.document("/usernames").getDocument { (snapshot, err) in
        if let err = err {
            print("Error: \(err)")
            completion(nil)
            return
        } else {
            let data = snapshot?.data()
            guard let listOfNames = data?.values else {
                print("Error, unable to retrieve names")
                completion(nil)
                return
            }
            for name in listOfNames {
                if let n = name as? String {
                    if n == username {
                        completion(false)
                        return
                    }
                } else {
                    print("Error, unable to unwrap names")
                    completion(nil)
                    return
                }
            }
            completion(true)
            return
        }
    }
}

func getSchoolList(completion: @escaping ([School]?) -> Void) {
    let schoolsRef = db.collection("schools")
    schoolsRef.getDocuments { (snapshot, err) in
        if let err = err {
            print("Error getting schools: \(err)")
            completion(nil)
        } else {
            guard let documents = snapshot?.documents else {
                print("Error getting school documents")
                completion(nil)
                return
            }
            var schoolList : [School] = []
            for document in documents {
                print(document.data())
                do {
                    let school = try School(data: document.data())
                    schoolList.append(school)
                } catch firebaseInterpretationError.invalidKeys {
                    return
                } catch {
                    return
                }
            }
            completion(schoolList)
        }
    }
}
