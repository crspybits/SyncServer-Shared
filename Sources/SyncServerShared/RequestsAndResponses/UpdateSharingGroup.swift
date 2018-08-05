//
//  UpdateSharingGroup.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 8/4/18.
//

import Foundation
import Gloss

#if SERVER
import Kitura
#endif

public class UpdateSharingGroupRequest : NSObject, RequestMessage {
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
        self.sharingGroupName = UpdateSharingGroupRequest.sharingGroupNameKey <~~ json
    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            ServerEndpoint.sharingGroupIdKey ~~> self.sharingGroupId,
            UpdateSharingGroupRequest.sharingGroupNameKey ~~> self.sharingGroupName
        ])
    }
    
    public func nonNilKeys() -> [String] {
        return [ServerEndpoint.sharingGroupIdKey, UpdateSharingGroupRequest.sharingGroupNameKey]
    }
    
    public func allKeys() -> [String] {
        return self.nonNilKeys()
    }
}

public class UpdateSharingGroupResponse : ResponseMessage {
    public var responseType: ResponseType {
        return .json
    }
    
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
