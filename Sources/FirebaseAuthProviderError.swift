//
//  FirebaseAuthProviderError.swift
//  FireBase-Auth-AmanGarry
//
//  Created by Gary Singh on 7/31/17.
//

import Vapor
import HTTP

public enum FirebaseAuthProviderError: Error {
    // Payload cases
    case noPayload
    case noPayloadExp
    case invalidPayloadExp
    case noPayloadIat
    case invalidPayloadIat
    case noPayloadAud
    case invalidPayloadAud
    case noPayloadIss
    case invalidPayloadIss
    case noPayloadSub
    case invalidPayloadSub
    
    // Header Cases
    case noHeader
    case noHeaderAlg
    case noHeaderKid
    case invalidHeaderAlg
    case noHeaderCacheControl
    case noHeaderMaxAge
    
    // Other Cases
    case noVerifiedJWT
    case noJWTSigner
    case noJWT
    case invalidToken
    
    // FetchKeys from Google Cases
    case noOkResponse
    case noResponse
    case noKidValue
    case noPublicKeysFetched
}

extension FirebaseAuthProviderError: AbortError {
    public var status: Status {
        switch self {
        default:
            return .unauthorized
            // Payload cases
            //        case .noPayloadExp:
            //            return .unauthorized
            //        case .invalidPayloadExp:
            //            return .unauthorized
            //        case .noPayloadIat:
            //            return .unauthorized
            //        case .invalidPayloadIat:
            //            return .unauthorized
            //        case .noPayloadAud:
            //            return .unauthorized
            //        case .invalidPayloadAud:
            //            return .unauthorized
            //        case .noPayloadIss:
            //            return .unauthorized
            //        case .invalidPayloadIss:
            //            return .unauthorized
            //        case .noPayloadSub:
            //            return .unauthorized
            //        case .invalidPayloadSub:
            //            return .unauthorized
            //
            //        // Header cases
            //        case .noHeaderAlg:
            //            return .unauthorized
            //        case .noHeaderKid:
            //            return .unauthorized
            //        case .invalidHeaderAlg:
            //            return .unauthorized
            //
            //        //
            //        case .noVerifiedJWT:
            //            return .unauthorized
            //        case .noJWTSigner:
            //            return .unauthorized
            //        case .noJWT:
            //            return .unauthorized
        }
    }
}

extension FirebaseAuthProviderError: Debuggable {
    public var reason: String {
        let message = " Make sure the ID token comes from the same Firebase project as the service account used to authenticate this SDK. See https://firebase.google.com/docs/auth/admin/verify-id-tokens for details on how to retrieve an ID token."
        
        switch self {
        // Payload cases
        case .noPayloadExp:
            return "Firebase ID token has no \'exp\' (expiration time) claim." + message
        case .invalidPayloadExp:
            return "Firebase ID token has expired. Get a fresh token from your client app and try again." + message
        case .noPayloadIat:
            return "Firebase ID token has no \'iat\' (issued-at time) claim." + message
        case .invalidPayloadIat:
            return "Firebase ID token has invalid issued-at time. Get a fresh token from your client app and try again." + message
        case .noPayloadAud:
            return "Firebase ID token has no \"aud\" claim." + message
        case .invalidPayloadAud:
            return "Firebase ID token \"aud\" (audience) don't match to Project ID." + message
        case .noPayloadIss:
            return "Firebase ID token has no \'iss\' claim." + message
        case .invalidPayloadIss:
            return "Firebase ID token has incorrect \'iss\' claim." + message
        case .noPayloadSub:
            return "Firebase ID token has no \'sub\' claim." + message
        case .invalidPayloadSub:
            return "Firebase ID token has invalid \'sub\' claim." + message
            
        // Header cases
        case .noHeaderAlg:
            return "Firebase ID token has no \"alg\" claim." + message
        case .noHeaderKid:
            return "Firebase ID token has no \"kid\" claim." + message
        case  .invalidHeaderAlg:
            return "Firebase ID token has incorrect algorithm." + message
        case .noHeaderCacheControl:
            return "Unable to get Firebase \'Cache-Control\' from header." + message
        case .noHeaderMaxAge:
            return "Unable to get Firebase \'max-age\' from header Cache-Control." + message
            
        case .noVerifiedJWT:
            return "JWT verification failed" + message
        case .noJWTSigner:
            return "Unable to get RS256 Signer for the kid Bytes" + message
        case .noJWT:
            return "Can't intialize the JWT, Invalid idToken passed." + message
            
        case .noOkResponse:
            return "Please try again, Unsuccessful response, not 200 from the Google url(firebase)." + message
        case .noResponse:
            return "Unable to make request to url, Please try again." + message
        case .noPayload:
            return "Unable to get response payload." + message
        case .noHeader:
            return "Unable to get respose header." + message
        case .invalidToken:
            return "Invalid token for JWT" + message
        case .noKidValue:
            return "Unable to get KidValue" + message
        case .noPublicKeysFetched:
            return "Kid values are not available from Firebase url" + message
        }
    }
    
    public var identifier: String {
        switch self {
        // Payload cases
        case .noPayloadExp:
            return "noPayloadExp"
        case .invalidPayloadExp:
            return "invalidPayloadExp"
        case .noPayloadIat:
            return "noPayloadIat"
        case .invalidPayloadIat:
            return "invalidPayloadIat"
        case .noPayloadAud:
            return "noPayloadAud"
        case .invalidPayloadAud:
            return "invalidPayloadAud"
        case .noPayloadIss:
            return "noPayloadIss"
        case .invalidPayloadIss:
            return "invalidPayloadIss"
        case .noPayloadSub:
            return "noPayloadSub"
        case .invalidPayloadSub:
            return "invalidPayloadSub"
            
        // Header cases
        case .noHeaderAlg:
            return "noHeaderAlg"
        case .noHeaderKid:
            return "noHeaderKid"
        case .invalidHeaderAlg:
            return "invalidHeaderAlg"
            
        // Other cases
        case .noVerifiedJWT:
            return "noVerifiedJWT"
        case .noJWTSigner:
            return "noJWTSigner"
        case .noJWT:
            return "noJWT"
            
        case .noPayload:
            return "noPayload"
        case .noHeader:
            return "noHeader"
        case .noHeaderCacheControl:
            return "noHeaderCacheControl"
        case .noHeaderMaxAge:
            return "noHeaderMaxAge"
        case .invalidToken:
            return "invalidToken"
        case .noOkResponse:
            return "noOkResponse"
        case .noResponse:
            return "noResponse"
        case .noKidValue:
            return "noKidValue"
        case .noPublicKeysFetched:
            return "noPublicKeysFetched"
        }
    }
    
    public var possibleCauses: [String] {
        return []
    }
    
    public var suggestedFixes: [String] {
        return []
    }
}
