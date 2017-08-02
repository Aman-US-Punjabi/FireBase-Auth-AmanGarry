//
//  RSAKey+PEM_2.swift
//  FireBase-Auth-AmanGarry
//
//  Created by Zsolt Váradi on 7/31/17.
//

import JWT
import CTLS

public extension RSAKey {
    
    init?(cert: String) {
        let bio = BIO_new(BIO_s_mem())
        defer {
            BIO_free(bio)
        }
        
        _ = cert.withCString { cert in
            BIO_puts(bio, cert)
        }
        
        guard let x509 = PEM_read_bio_X509(bio, nil, nil, nil) else {
            return nil
        }
        
        defer {
            X509_free(x509)
        }
        
        guard let pubKey = X509_get_pubkey(x509) else {
            return nil
        }
        
        defer {
            EVP_PKEY_free(pubKey)
        }
        
        guard let rsa = EVP_PKEY_get1_RSA(pubKey) else {
            return nil
        }
        
        self = .public(rsa)
    }
}

extension RSASigner {
    public init(cert: String) throws {
        guard let rsaKey = RSAKey(cert: cert) else {
            throw JWTError.createPublicKey
        }
        
        try self.init(rsaKey: rsaKey)
    }
}

