//
//  HealthCheck.swift
//  Server
//
//  Created by Christopher Prince on 11/26/16.
//
//

import Foundation

public class HealthCheckRequest : RequestMessage {
    public func valid() -> Bool {
        return true
    }
}

public class HealthCheckResponse : ResponseMessage {
    public var responseType: ResponseType {
        return .json
    }
    
    public var currentServerDateTime:Date!
    public var serverUptime:TimeInterval!
    public var deployedGitTag:String!
    public var diagnostics:String?
}
