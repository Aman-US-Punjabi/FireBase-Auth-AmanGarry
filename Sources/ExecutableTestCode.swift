//
//  ExecutableTestCode.swift
//  FireBase-Auth-AmanGarry
//
//  Created by Gary Singh on 7/31/17.
//
//  This is the code to test

import Vapor
import HTTP
import JWT

// Put your token
let idToken = "Your token"

// Put your project id
let PROJECT_ID = "Project Id"

// Valid Algorithm for FireBase Token  verification
let ALGORITHM = "RS256"


// Url to get Public keys from FireBase
let CLIENT_CERT_URL = "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"

// Http client to make request to external servers
let httpClient = EngineClient.factory

// public keys and expiration time
var publicKeysExpiresAt : Date?          = nil
var publicKeys : [String : String]?     = nil


func getPublicKeysExpireDataFrmCacheControl(from cacheControl: String) -> Date? {
    let cacheControlParts = cacheControl.components(separatedBy: ", ")
    for part in cacheControlParts {
        let subParts = part.split(separator: "=")
        if subParts[0] == "max-age" {
            if let maxAge = Double(subParts[1].lowercased()) {
                print(maxAge)
                let today = Date()
                let publicKeysExpiresAt = Date.init(timeIntervalSinceNow: maxAge)
                print(today)
                print(publicKeysExpiresAt)
                return publicKeysExpiresAt
            }
        }
    }
    return nil
}

// Fetches the public keys from the Google certs
func fetchPublicKeys() -> (errors: [String]?, keys: [String:String]?) {
    var keyPairs : [String : String] = [:]
    var errors: [String] = []
    
    // Check if publicKeys already exists, publicKeyExpiresAt already exists
    // and publicKeysExpiresAt time is still valid, then return already existing
    // publicKeys no need to fetch again, as already existing publicKeys are valid.
    if let keys =  publicKeys, let keysExpiresAt = publicKeysExpiresAt, Date() < keysExpiresAt {
        return (errors, keys)
    }
    
    // if keys expired then fetch new keys
    do {
        let firebaseResponse = try httpClient.get(CLIENT_CERT_URL)
        
        // if response is not ok or 200 then return nil keys
        if firebaseResponse.status.hashValue != 200 {
            // Return nil
            errors.append("Please try again, Unsuccessful response!")
            publicKeys = nil
            return (errors, nil)
        }
        
        // Get Cache-Control value from header, if unable to do so,
        // then return nil keys
        guard let cacheControl = firebaseResponse.headers["Cache-Control"] else {
            errors.append("Unable to get Firebase \'Cache-Control\' from header!")
            publicKeys = nil
            return (errors, nil)
        }
        print(cacheControl)
        
        guard let publicKeysExpiresAtDate = getPublicKeysExpireDataFrmCacheControl(from: cacheControl) else {
            // Unable to get expirationDate
            errors.append("Unable to get Firebase \'max-age\' from header Cache-Control!")
            publicKeys = nil
            return (errors, nil)
        }
        
        publicKeysExpiresAt = publicKeysExpiresAtDate
        
        //        firebaseResponse.headers.forEach({ (key, value) in
        //            print("Key: \(key), Value: \(value)")
        //        })
        
        if let jsonData = firebaseResponse.json {
            if let jsonDict = jsonData.object {
                for (key, value) in jsonDict {
                    if let value = value.string {
                        keyPairs[key] = value
                    }
                }
                if !keyPairs.isEmpty {
                    publicKeys = keyPairs
                    return (nil, keyPairs)
                }
            }
        }
    } catch {
        print("In catch")
    }
    return (nil, nil)
}

func verifyIDToken(idToken: String) {
    if idToken == "" {
        // TO DO Thow error Invalid IdToken
        return
    }
    
    // Get firebase project Id
    
    // Decodes a token string into a JWT using JWT
    do {
        let jwt = try JWT(token: idToken)
        print("---------------------------")
        print(jwt)
        print("---------------------------")
        
        // Get header
        guard let header = jwt.headers.object else {
            print("Unable to get respose header.")
            return
        }
        
        // Get Payload
        guard let payload = jwt.payload.object else {
            print("Unable to get response payload.")
            return
        }
        
        let projectIdMatchMessage = " Make sure the ID token comes from the same Firebase project as the service account used to authenticate this SDK."
        
        let verifyIdTokenDocsMessage = " See https://firebase.google.com/docs/auth/admin/verify-id-tokens for details on how to retrieve an ID token."
        
        // Validate header's keys and values
        // get the kid from the header
        guard let kid = header["kid"]?.string else {
            print("Firebase ID token has no \"kid\" claim.")
            return
        }
        
        // get algorithm from the header
        guard let alg = header["alg"]?.string else {
            print("Firebase ID token has no \"alg\" claim.")
            return
        }
        // if algorithm do not match then show error
        if alg != ALGORITHM {
            print("Firebase ID token has incorrect algorithm. Expected \'\(ALGORITHM)\' but got \'\(alg)\'")
            return
        }
        
        print("Alg: \(alg) \nKid: \(kid)")
        
        // Validate payload keys and payload
        guard let aud = payload[AudienceClaim.name]?.string else {
            print("Firebase ID token has no \"aud\" claim.")
            return
        }
        if aud != PROJECT_ID {
            print("Firebase ID token has incorrect \"aud\" (audience) claim. Expected \'\(PROJECT_ID)\' but got \'\(aud)\'" + projectIdMatchMessage + verifyIdTokenDocsMessage)
        }
        
        guard let iss = payload[IssuerClaim.name]?.string else {
            print("Firebase ID token has no \'iss\' claim.")
            return
        }
        if iss != "https://securetoken.google.com/\(PROJECT_ID)" {
            print("Firebase ID token has incorrect \'iss\' claim. Expected https://securetoken.google.com/\(PROJECT_ID). But got \'\(iss)\'."  + projectIdMatchMessage + verifyIdTokenDocsMessage)
        }
        
        guard let sub = payload[SubjectClaim.name]?.string else {
            print("Firebase ID token has no \'sub\' claim." + verifyIdTokenDocsMessage)
            return
        }
        if sub == "" {
            print("Firebase ID token has an empty string \'sub\' (subject) claim." + verifyIdTokenDocsMessage)
        } else if sub.characters.count > 128 {
            print("Firebase ID token has string \'sub\' (subject) claim longer than 128 characters." + verifyIdTokenDocsMessage)
        }
        
        guard let exp = payload[ExpirationTimeClaim.name]?.string else {
            print("Firebase ID token has no \'exp\' (expiration time) claim." + projectIdMatchMessage + verifyIdTokenDocsMessage)
            return
        }
        // TODO Check exp (expiration time) in seconds Must be in the future.
        
        guard let iat = payload[IssuedAtClaim.name]?.string else {
            print("Firebase ID token has no \'iat\' (issued-at time) claim." + projectIdMatchMessage + verifyIdTokenDocsMessage)
            return
        }
        // TODO Check iat (issued-at time) in seconds Must be in the past.
        
        // fetch all public keys
        let keyResult = fetchPublicKeys()
        
        // If error occured while fetching keys
        // return error
        if let errors = keyResult.errors {
            print(errors)
            return
        }
        
        guard let keyPair = keyResult.keys else {
            print()
            return
        }
        
        let kidValue = keyPair[kid]
        
        // Verify JWT Token with kidValue and tokenId
        
    } catch {
        print("Can't intialize the JWT, Invalid idToken passed.")
    }
}

verifyIDToken(idToken: idToken)
