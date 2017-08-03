//
//  Req+HeaderToken.swift
//  FireBase-Auth-AmanGarry
//
//  Created by Gary Singh on 8/2/17.
//

import HTTP
import Authentication

extension Request {
    // Returns and sets the "Authorization: Bearear"  header
    // from the reqest
    public var header: AuthorizationHeader? {
        get {
            guard let authorization = self.headers["Authorization"] else {
                guard let query = self.query else {
                    return nil
                }
                
                if let bearer = query["_authorizationBearer"]?.string {
                    return AuthorizationHeader(string: "Bearer \(bearer)")
                } else if let basic = query["_authorizationBasic"]?.string {
                    return AuthorizationHeader(string: "Basic \(basic)")
                } else {
                    return nil
                }
            }
            
            return AuthorizationHeader(string: authorization)
        }
        
        set {
            self.headers[.authorization] = newValue?.string
        }
    }
}
