//
//  HealthCheck.swift
//  Server
//
//  Created by Christopher Prince on 11/26/16.
//
//

import Foundation

public class HealthCheckRequest : RequestMessage {
    required public init() {}

    public func valid() -> Bool {
        return true
    }
}

public class HealthCheckResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .json
    }
    
    public var currentServerDateTime:Date!
    public var serverUptime:TimeInterval!
    public var deployedGitTag:String!
    public var diagnostics:String?
}
