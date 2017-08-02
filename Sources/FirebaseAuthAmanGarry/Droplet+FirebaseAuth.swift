//
//  Droplet+FirebaseAuth.swift
//  FireBase-Auth-AmanGarry
//
//  Created by Gary Singh on 8/2/17.
//
//

import Vapor

extension Droplet {
    public internal(set) var firebaseProjectId: String? {
        get { return self.firebaseProjectId }
        set {
            self.firebaseProjectId = newValue
        }
    }
}
