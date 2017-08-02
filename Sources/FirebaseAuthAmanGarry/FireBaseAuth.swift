//
//  FirebaseAuth.swift
//  FireBase-Auth-AmanGarry
//
//  Created by Gary Singh on 7/31/17.
//

import Vapor
import HTTP
import JWT

public final class FirebaseAuth {

    // Valid Algorithm for FireBase Token  verification
    private let ALGORITHM = "RS256"
    
    // Url to get Public keys from FireBase
    private let CLIENT_CERT_URL = "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"
    
    // Http client to make request to external servers
    private let httpClient = EngineClient.factory
    
    // public keys and expiration time
    private var publicKeysExpiresAt : Date?         = nil
    private var publicKeys : [String : String]?     = nil
    
    private func getPublicKeysExpireDateFrmCacheControl(from cacheControl: String) throws -> Date? {
        let cacheControlParts = cacheControl.components(separatedBy: ", ")
        for part in cacheControlParts {
            let subParts = part.components(separatedBy: "=")
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
        throw FirebaseAuthProviderError.noHeaderMaxAge
    }
    
    // Fetches the public keys from the Google certs
    private func fetchPublicKeys() throws {
        
        // Check if publicKeys already exists, publicKeyExpiresAt already exists
        // and publicKeysExpiresAt time is still valid, then return already existing
        // publicKeys no need to fetch again, as already existing publicKeys are valid.
        if let keys =  publicKeys, let keysExpiresAt = publicKeysExpiresAt, Date() < keysExpiresAt {
            publicKeys = keys
            return
        }
        
        // if keys expired then fetch new keys
        
        // Get response from url
        let firebaseResponse : Response
        do {
            firebaseResponse = try httpClient.get(CLIENT_CERT_URL)
        } catch {
            throw FirebaseAuthProviderError.noResponse
        }
        
        // if response is not ok or 200 then return nil keys
        if firebaseResponse.status.hashValue != 200 {
            // Return nil
            throw FirebaseAuthProviderError.noOkResponse
        }
        
        // Get Cache-Control value from header, if unable to do so,
        // then return nil keys
        guard let cacheControl = firebaseResponse.headers["Cache-Control"] else {
            throw FirebaseAuthProviderError.noHeaderCacheControl
        }
        
        let publicKeysExpiresAtDate = try getPublicKeysExpireDateFrmCacheControl(from: cacheControl)
        
        // Set the new expiration time value for the public keys
        publicKeysExpiresAt = publicKeysExpiresAtDate
        
        // get all keys and their values
        if let jsonData = firebaseResponse.json {
            if let jsonDict = jsonData.object {
                var keyPairs : [String:String] = [:]
                for (key, value) in jsonDict {
                    if let value = value.string {
                        keyPairs[key] = value
                    }
                }
                if !keyPairs.isEmpty {
                    publicKeys = keyPairs
                    return
                }
            }
        }
    }
    
    func verifyIDToken(projectId: String, idToken: String) throws {
        if idToken == "" {
            // TO DO Thow error Invalid IdToken
            throw FirebaseAuthProviderError.invalidToken
        }
        
        // Get firebase project Id
        
        // Decodes a token string into a JWT using JWT
        let jwt : JWT
        do {
            jwt = try JWT(token: idToken)
        } catch {
            throw FirebaseAuthProviderError.noJWT
        }
        print("---------------------------")
        print(jwt)
        print("---------------------------")
        
        // Get header
        guard let header = jwt.headers.object else {
            throw FirebaseAuthProviderError.noHeader
        }
        
        // Get Payload
        guard let payload = jwt.payload.object else {
            throw FirebaseAuthProviderError.noPayload
        }
        
        // Validate header's keys and values
        // get the kid from the header
        guard let kid = header[KeyIDHeader.name]?.string else {
            throw FirebaseAuthProviderError.noHeaderKid
        }
        
        // get algorithm from the header
        guard let alg = header[AlgorithmHeader.name]?.string else {
            throw FirebaseAuthProviderError.noHeaderAlg
        }
        // if algorithm do not match then show error
        if alg != ALGORITHM {
            throw FirebaseAuthProviderError.invalidHeaderAlg
        }
        
        // Validate payload keys and payload
        
        guard let aud = payload[AudienceClaim.name]?.string else {
            throw FirebaseAuthProviderError.noPayloadAud
        }
        if aud != projectId {
            throw FirebaseAuthProviderError.invalidPayloadAud
        }
        
        guard let iss = payload[IssuerClaim.name]?.string else {
            throw FirebaseAuthProviderError.noPayloadIss
        }
        if iss != "https://securetoken.google.com/\(projectId)" {
            throw FirebaseAuthProviderError.invalidPayloadIss
        }
        
        guard let sub = payload[SubjectClaim.name]?.string else {
            throw FirebaseAuthProviderError.noPayloadSub
        }
        if sub == "" || sub.characters.count > 128  {
            throw FirebaseAuthProviderError.invalidPayloadSub
        }
        
        guard let exp = payload[ExpirationTimeClaim.name]?.double else {
            throw FirebaseAuthProviderError.noPayloadExp
        }
        // exp (expiration time) in seconds Must be in the future.
        if (Date(timeIntervalSince1970: exp) < Date()) {
            throw FirebaseAuthProviderError.invalidPayloadExp
        }
        
        guard let iat = payload[IssuedAtClaim.name]?.double else {
            throw FirebaseAuthProviderError.noPayloadIat
        }
        // iat (issued-at time) in seconds Must be in the past.
        if (Date(timeIntervalSince1970: iat) >= Date()) {
            throw FirebaseAuthProviderError.invalidPayloadIat
        }
        
        // fetch all public keys
        try fetchPublicKeys()
        
        // check if publicKeys exists
        guard let keyPair = publicKeys else {
            throw FirebaseAuthProviderError.noPublicKeysFetched
        }
        
        guard let kidValue = keyPair[kid] else {
            throw FirebaseAuthProviderError.noPublicKeysFetched
        }
        
        let signer: Signer
        do {
            signer = try RS256(cert: kidValue)
        } catch {
            throw FirebaseAuthProviderError.noJWTSigner
        }
        
        do {
            try jwt.verifySignature(using: signer)
            // Successfully verified if got here
            print("Successfully verified")
        } catch {
            // To DO
            throw FirebaseAuthProviderError.noVerifiedJWT
        }
    }
}
