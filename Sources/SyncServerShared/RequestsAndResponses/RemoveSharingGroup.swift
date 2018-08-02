//
//  RemoveSharingGroup.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 8/1/18.
//

import Foundation
import Gloss

#if SERVER
import Kitura
#endif

public class RemoveSharingGroupRequest : NSObject, RequestMessage {
    public var sharingGroupId:SharingGroupId!
    
#if SERVER
    public required convenience init?(request: RouterRequest) {
        self.init(json: request.queryParameters)
    }
#endif
    
    public required init?(json: JSON) {
        super.init()
        self.sharingGroupId = Decoder.decode(int64ForKey: ServerEndpoint.sharingGroupIdKey)(json)
    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            ServerEndpoint.sharingGroupIdKey ~~> self.sharingGroupId
        ])
    }
    
    public func nonNilKeys() -> [String] {
        return [ServerEndpoint.sharingGroupIdKey]
    }
    
    public func allKeys() -> [String] {
        return self.nonNilKeys()
    }
}

public class RemoveSharingGroupResponse : ResponseMessage {
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
