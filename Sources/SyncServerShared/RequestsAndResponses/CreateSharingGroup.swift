//
//  CreateSharingGroup.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 7/30/18.
//

import Foundation
import Gloss

#if SERVER
import Kitura
#endif

// The current signed in user is requesting creation of a sharing group.

public class CreateSharingGroupRequest : NSObject, RequestMessage {
    // You do *not* supply the sharing group id in this sharing group. It is created by this request.
    public static let sharingGroupKey = "sharingGroup"
    public var sharingGroup: SharingGroup!
    
#if SERVER
    public required convenience init?(request: RouterRequest) {
        self.init(json: request.queryParameters)
    }
#endif
    
    public required init?(json: JSON) {
        super.init()
        self.sharingGroup = CreateSharingGroupRequest.sharingGroupKey <~~ json
    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            CreateSharingGroupRequest.sharingGroupKey ~~> self.sharingGroup
        ])
    }
    
    public func nonNilKeys() -> [String] {
        return []
    }
    
    public func allKeys() -> [String] {
        return self.nonNilKeys()
    }
}

public class CreateSharingGroupResponse : ResponseMessage {
    public var sharingGroupId:SharingGroupId!
    
    public var responseType: ResponseType {
        return .json
    }
    
    public required init?(json: JSON) {
        self.sharingGroupId = Decoder.decode(int64ForKey: ServerEndpoint.sharingGroupIdKey)(json)
    }
    
    public convenience init?() {
        self.init(json:[:])
    }
    
    // MARK: - Serialization
    public func toJSON() -> JSON? {
        return jsonify([
            ServerEndpoint.sharingGroupIdKey ~~> self.sharingGroupId
        ])
    }
}

