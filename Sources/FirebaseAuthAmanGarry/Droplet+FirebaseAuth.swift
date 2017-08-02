//
//  Droplet+FirebaseAuth.swift
//  FireBase-Auth-AmanGarry
//
//  Created by Gary Singh on 8/2/17.
//
//

import Vapor

private let firebaseProjectIdKey = "firbase-project-id"

extension Droplet {
    
    public internal(set) var firebaseProjectId: String? {
        get {
            return storage[firebaseProjectIdKey] as? String
        }
        set {
            print("In drop set firebase project id. with new Value: \(newValue)")
            storage[firebaseProjectIdKey] = newValue
        }
    }
}
