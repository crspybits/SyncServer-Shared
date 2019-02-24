//
//  RequestMessage.swift
//  Server
//
//  Created by Christopher Prince on 11/26/16.
//
//

import Foundation

#if SERVER
import PerfectLib
import Kitura
#endif

public protocol RequestMessage : Codable {
    func valid() -> Bool
    
#if SERVER
    func setup(request: RouterRequest) throws
#endif
}

public extension RequestMessage {
#if SERVER
    public func setup(request: RouterRequest) throws {
    }
#endif

/*
    public func urlParameters() -> String? {
        // 6/9/17; I was previously using reflection to do this, and not just converting to a dict. Can't recall why. However, this started giving me grief when I started using dates.
        guard let jsonDict = toJSON() else {
#if SERVER
            Log.error(message: "Could not convert toJSON()!")
#endif
            return nil
        }
        
        var result = ""
        for key in self.allKeys() {
            if let keyValue = jsonDict[key] {
                if result.count > 0 {
                    result += "&"
                }
                
                let newURLParameter = "\(key)=\(keyValue)"
                
                if let escapedNewKeyValue = newURLParameter.escape() {
                    result += escapedNewKeyValue
                }
                else {
#if SERVER
                    Log.critical(message: "Failed on escaping new key value!")
#endif
#if DEBUG
                    assert(false)
#endif
                }
            }
        }
        
        if result.count == 0 {
            return nil
        }
        else {
            return result
        }
    }
*/
}

