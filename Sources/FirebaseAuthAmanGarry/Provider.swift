//
//  Provider.swift
//  FireBase-Auth-AmanGarry
//
//  Created by Gary Singh on 7/29/17.
//

import Vapor

// Add FireBase-Auth-AmanGarry to the Vapor application
public final class Provider: Vapor.Provider {
    public static let repositoryName = "firebase-auth-provider"
    
    public let projectId : String?
    
    public init(projectId: String) {
        self.projectId  = projectId
    }
    
    public convenience init(config: Config) throws {
        guard let firebaseAuthConfig = config["firebaseauth"] else {
            throw ConfigError.missingFile("firebaseauth")
        }
        
        guard let projectId = firebaseAuthConfig["projectId"]?.string else {
            throw ConfigError.missing(key: ["projectId"], file: "firebaseauth", desiredType: String.self)
        }
        
        self.init(projectId: projectId)
    }
    
    public func boot(_ config: Config) throws {}
    
    // Called to prepare the Droplet.
    public func boot(_ drop: Droplet) throws {
        drop.firebaseProjectId = self.projectId
    }
    
    /// Called after the Droplet has completed
    /// initialization and all provided items
    /// have been accepted.
    public func afterInit(_ drop: Droplet) throws {}
    
    /// Called before the Droplet begins serving
    /// which is @noreturn.
    public func beforeRun(_ drop: Droplet) throws {}
}
