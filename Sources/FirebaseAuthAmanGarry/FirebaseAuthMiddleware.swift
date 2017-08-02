//
//  FirebaseAuthMiddleware.swift
//  FireBase-Auth-AmanGarry
//
//  Created by Gary Singh on 8/1/17.
//

import Foundation
import HTTP

public final class FirebaseAuthMiddleware: Middleware {
    
    
    let projectId : String
    
    let firebaseAuth : FirebaseAuth
    
    public init(projectId: String) {
        firebaseAuth = FirebaseAuth()
        self.projectId = projectId
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        let response = try next.respond(to: request)
        
        print(response)
        
        print("ProjectId: Middleware: \(projectId)")
        
        //
        
//        try firebaseAuthAmanGarry.verifyIDToken(projectId: <#T##String#>, idToken: <#T##String#>)
        
        return response
    }
}
