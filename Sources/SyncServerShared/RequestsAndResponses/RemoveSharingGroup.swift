//
//  RemoveSharingGroup.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 8/1/18.
//

import Foundation

public class RemoveSharingGroupRequest : RequestMessage, MasterVersionUpdateRequest {
    required public init() {}

    public var masterVersion: MasterVersionInt!
    
    public var sharingGroupUUID:String!
    
    public func valid() -> Bool {
        return sharingGroupUUID != nil && masterVersion != nil
    }
    
    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try RequestMessageDecoder.decode(RemoveSharingGroupRequest.self, from: dictionary)
    }
}

public class RemoveSharingGroupResponse : ResponseMessage, MasterVersionUpdateResponse {
    required public init() {}

    public var masterVersionUpdate: MasterVersionInt?
    
    public var responseType: ResponseType {
        return .json
    }
}
