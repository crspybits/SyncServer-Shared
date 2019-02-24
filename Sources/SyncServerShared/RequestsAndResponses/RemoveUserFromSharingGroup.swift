//
//  RemoveUserFromSharingGroup.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 8/1/18.
//

import Foundation

public class RemoveUserFromSharingGroupRequest : RequestMessage, MasterVersionUpdateRequest {
    required public init() {}

    public var masterVersion: MasterVersionInt!
    public var sharingGroupUUID:String!

    public func valid() -> Bool {
        return sharingGroupUUID != nil && masterVersion != nil
    }
}

public class RemoveUserFromSharingGroupResponse : ResponseMessage, MasterVersionUpdateResponse {
    required public init() {}

    public var masterVersionUpdate: MasterVersionInt?
    
    public var responseType: ResponseType {
        return .json
    }
}
