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
    // You must supply the sharing group id, and the name-- the name is the only attribute you can currently change-- you cannot change the delete attribute (use the RemoveSharingGroup endpoint for that).
    public static let sharingGroupKey = "sharingGroup"
    public var sharingGroup: SharingGroup!
    
#if SERVER
    public required convenience init?(request: RouterRequest) {
        self.init(json: request.queryParameters)
    }
#endif
    
    public required init?(json: JSON) {
        super.init()
        self.sharingGroup = UpdateSharingGroupRequest.sharingGroupKey <~~ json
    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            UpdateSharingGroupRequest.sharingGroupKey ~~> self.sharingGroup
        ])
    }
    
    public func nonNilKeys() -> [String] {
        return [UpdateSharingGroupRequest.sharingGroupKey]
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
