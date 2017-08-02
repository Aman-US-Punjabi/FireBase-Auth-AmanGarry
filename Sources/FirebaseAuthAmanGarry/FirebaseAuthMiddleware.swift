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
    
    
    var projectId : String
    
    var firebaseAuth : FirebaseAuth
    
    public init() {
        firebaseAuth = FirebaseAuth()
        self.projectId = ""
    }
    
    public convenience init(config: Config) throws {
        
        guard let firebaseAuthConfig = config["firebaseauth"] else {
            throw ConfigError.missingFile("firebaseauth")
        }
        print("Config: Middleware: \(firebaseAuthConfig)")
        
        guard let projectId = firebaseAuthConfig["projectId"]?.string else {
            throw ConfigError.missing(key: ["projectId"], file: "firebaseauth", desiredType: String.self)
        }
        
        self.init()
        
        self.projectId = projectId
        
        print("ProjectId: Middleware: \(projectId)")
        
        firebaseAuth = FirebaseAuth()
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
