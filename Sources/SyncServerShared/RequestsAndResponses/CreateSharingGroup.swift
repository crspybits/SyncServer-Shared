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

// The current signed in user is requesting creation of a sharing group. A sharing group name is optional because some clients may not need or want a name per sharing group.

public class CreateSharingGroupRequest : NSObject, RequestMessage {
    // I'm having problems uploading complex objects in url parameters. So not sending a SharingGroup object yet. If I need to do this, looks like I'll have to use the request body and am not doing that yet.
    public static let sharingGroupNameKey = "sharingGroupName"
    public var sharingGroupName: String?
    
#if SERVER
    public required convenience init?(request: RouterRequest) {
        self.init(json: request.queryParameters)
    }
#endif
    
    public required init?(json: JSON) {
        super.init()
        self.sharingGroupName = CreateSharingGroupRequest.sharingGroupNameKey <~~ json
        
        if !nonNilKeysHaveValues(in: json) {
            return nil
        }
    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            CreateSharingGroupRequest.sharingGroupNameKey ~~> self.sharingGroupName
        ])
    }
    
    public func nonNilKeys() -> [String] {
        return []
    }
    
    public func allKeys() -> [String] {
        return self.nonNilKeys() + [CreateSharingGroupRequest.sharingGroupNameKey]
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

