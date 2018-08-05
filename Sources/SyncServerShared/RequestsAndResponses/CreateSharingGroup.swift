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
    // I'm having problems uploading complex objects in url parameters. So not sending a SharingGroup object yet. If I need to do this, looks like I'll have to use the request body and am not doing that yet.
    public var sharingGroupId: SharingGroupId!
    
    public static let sharingGroupNameKey = "sharingGroupName"
    public var sharingGroupName: String?
    
#if SERVER
    public required convenience init?(request: RouterRequest) {
        self.init(json: request.queryParameters)
    }
#endif
    
    public required init?(json: JSON) {
        super.init()
        self.sharingGroupId = Decoder.decode(int64ForKey: ServerEndpoint.sharingGroupIdKey)(json)
        self.sharingGroupName = CreateSharingGroupRequest.sharingGroupNameKey <~~ json
    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            ServerEndpoint.sharingGroupIdKey ~~> self.sharingGroupId,
            CreateSharingGroupRequest.sharingGroupNameKey ~~> self.sharingGroupName
        ])
    }
    
    public func nonNilKeys() -> [String] {
        return [ServerEndpoint.sharingGroupIdKey, CreateSharingGroupRequest.sharingGroupNameKey]
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

