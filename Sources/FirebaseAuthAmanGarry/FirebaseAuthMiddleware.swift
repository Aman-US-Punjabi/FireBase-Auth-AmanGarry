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
    
    var firebaseAuth : FirebaseAuth
    
    public init() {
        firebaseAuth = FirebaseAuth()
    }
    
    public convenience init(config: Config) throws {
        
        self.init()
        
        self.firebaseAuth = try FirebaseAuth(config: config)
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        let response = try next.respond(to: request)
        
        print(response)
        
        //
        
        //        try firebaseAuthAmanGarry.verifyIDToken(projectId: <#T##String#>, idToken: <#T##String#>)
        
        return response
    }
}
