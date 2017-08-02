//
//  FirebaseAuthMiddleware.swift
//  FireBase-Auth-AmanGarry
//
//  Created by Gary Singh on 8/1/17.
//

import Foundation
import Vapor
import HTTP

public final class FirebaseAuthMiddleware: Middleware {
    
    let firebaseAuth            :   FirebaseAuth
    let firebaseProjectId       :   String
    
    public init(with firebaseProjectId: String) {
        firebaseAuth = FirebaseAuth()
        self.firebaseProjectId = firebaseProjectId
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        let response = try next.respond(to: request)
        
        print(response)
        
        //
        print("Project Id in Middleware: \(firebaseProjectId)")
        try firebaseAuth.verifyIDToken(projectId: firebaseProjectId, idToken: "asdadsasd")
        
        return response
    }
}
