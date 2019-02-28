//
//  RequestMessage.swift
//  Server
//
//  Created by Christopher Prince on 11/26/16.
//
//

import Foundation

#if SERVER
import Kitura
import LoggerAPI
#endif

public protocol RequestMessage : Codable {
    init()
    
    func valid() -> Bool
    
#if SERVER
    func setup(request: RouterRequest) throws
#endif

    static func decode(_ dictionary: [String: Any]) throws -> RequestMessage
}

public extension RequestMessage {
#if SERVER
    public func setup(request: RouterRequest) throws {
    }
#endif

    public func urlParameters() -> String? {
        guard let jsonDict = toDictionary else {
#if SERVER
            Log.error("Could not convert toJSON()!")
#endif
            return nil
        }
        
        var result = ""
        for key in jsonDict.keys {
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
                    Log.critical("Failed on escaping new key value: \(newURLParameter)")
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
}

