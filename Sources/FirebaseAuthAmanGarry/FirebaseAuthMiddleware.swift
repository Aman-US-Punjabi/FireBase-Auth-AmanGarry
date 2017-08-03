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
    
    
    internal private(set) var firebaseProjectId :   String
    
    let firebaseAuth    :   FirebaseAuth
    
    public init(with firebaseProjectId: String) {
        print("In Middleware init")
        firebaseAuth = FirebaseAuth()
        self.firebaseProjectId = firebaseProjectId
        print("Exit middleware init")
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        let response = try next.respond(to: request)
        
        guard let token = request.header?.bearer else {
            print("Header has no token.")
            throw FirebaseAuthProviderError.invalidToken
        }
        print("token: \(token)")
        //
        print("Project Id in Middleware: \(firebaseProjectId)")
        try firebaseAuth.verifyIDToken(projectId: firebaseProjectId, idToken: "asdadsasd")
        
        return response
    }
}
