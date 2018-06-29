//
//  DBQueries.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/27/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import Foundation
import Firebase

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
