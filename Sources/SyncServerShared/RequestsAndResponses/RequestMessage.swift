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
}

