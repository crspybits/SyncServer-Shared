//
//  GetSharingGroupUsers.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 8/4/18.
//

import Foundation
import Gloss

#if SERVER
import Kitura
import PerfectLib
#endif

public class GetSharingGroupUsersRequest : NSObject, RequestMessage {
    public var sharingGroupId: SharingGroupId!
 
    public required init?(json: JSON) {
        super.init()
        self.sharingGroupId = Decoder.decode(int64ForKey: ServerEndpoint.sharingGroupIdKey)(json)

        if !nonNilKeysHaveValues(in: json) {
            return nil
        }
    }

    public func toJSON() -> JSON? {
        return jsonify([
            ServerEndpoint.sharingGroupIdKey ~~> self.sharingGroupId
        ])
    }
    
#if SERVER
    public required convenience init?(request: RouterRequest) {
        self.init(json: request.queryParameters)
    }
#endif
    
    public func allKeys() -> [String] {
        return self.nonNilKeys()
    }
    
    public func nonNilKeys() -> [String] {
        return [ServerEndpoint.sharingGroupIdKey]
    }
}

public class GetSharingGroupUsersResponse : ResponseMessage {
    public var responseType: ResponseType {
        return .json
    }
    
    public static let sharingGroupUsersKey = "sharingGroupUsers"
    public var sharingGroupUsers:[SharingGroupUser]!
    
    public required init?(json: JSON) {
        self.sharingGroupUsers = GetSharingGroupUsersResponse.sharingGroupUsersKey <~~ json
    }
    
    public convenience init?() {
        self.init(json:[:])
    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            GetSharingGroupUsersResponse.sharingGroupUsersKey ~~> self.sharingGroupUsers
        ])
    }
}

