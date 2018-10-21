//
//  CheckCreds.swift
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

// Check to see if both primary and secondary authentication succeed. i.e., check to see if a user exists.

public class CheckCredsRequest : NSObject, RequestMessage {
    public required init?(json: JSON) {
        super.init()
        
        if !nonNilKeysHaveValues(in: json) {
            return nil
        }
    }
    
#if SERVER
    public required init?(request: RouterRequest) {
        super.init()
    }
#endif

    public func toJSON() -> JSON? {
        return jsonify([
        ])
    }
}

public class CheckCredsResponse : ResponseMessage {
    // Present only as means to help clients uniquely identify users. This is *never* passed back to the server. This id is unique across all users and is not specific to any sign-in type (e.g., Google).
    public static let userIdKey = "userId"
    public var userId:UserId!
    
    // For owning users, this just reflects their account type.
    // For sharing users, this reflects the cloud storage type of their "parent" user-- where their v0 files get stored when uploaded. This is optional because under some circumstances it can be nil.
    public static let cloudStorageTypeKey = "cloudStorageType"
    public var cloudStorageType: String?
    
    public var responseType: ResponseType {
        return .json
    }
    
    public required init?(json: JSON) {
        userId = Decoder.decode(int64ForKey: CheckCredsResponse.userIdKey)(json)
        cloudStorageType = CheckCredsResponse.cloudStorageTypeKey <~~ json
    }
    
    public convenience init?() {
        self.init(json:[:])
    }
    
    // MARK: - Serialization
    public func toJSON() -> JSON? {
        return jsonify([
            CheckCredsResponse.userIdKey ~~> userId,
            CheckCredsResponse.cloudStorageTypeKey ~~> self.cloudStorageType
        ])
    }
}
