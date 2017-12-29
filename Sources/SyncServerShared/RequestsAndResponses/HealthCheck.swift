//
//  HealthCheck.swift
//  Server
//
//  Created by Christopher Prince on 11/26/16.
//
//

import Foundation
import Gloss

#if SERVER
import Kitura
#endif

public class HealthCheckRequest : NSObject, RequestMessage {
    public required init?(json: JSON) {
        super.init()
    }
    
#if SERVER
    public required convenience init?(request: RouterRequest) {
        self.init(json: request.queryParameters)
    }
#endif
    
    public func toJSON() -> JSON? {
        return jsonify([
        ])
    }
}

public class HealthCheckResponse : ResponseMessage {
    public var responseType: ResponseType {
        return .json
    }
    
    public static let serverUptimeKey = "serverUptime"
    public var serverUptime:TimeInterval!

    public static let deployedGitTagKey = "deployedGitTag"
    public var deployedGitTag:String!
    
    public static let diagnosticsKey = "diagnostics"
    public var diagnostics:String!

    public required init?(json: JSON) {
    }
    
    public convenience init?() {
        self.init(json:[:])
    }
    
    // MARK: - Serialization
    public func toJSON() -> JSON? {
        return jsonify([
        ])
    }
}
