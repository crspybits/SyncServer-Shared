//
//  RemoveSharingGroup.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 8/1/18.
//

import Foundation

public class RemoveSharingGroupRequest : RequestMessage, MasterVersionUpdateRequest {
    public var masterVersion: MasterVersionInt!
    
    public var sharingGroupUUID:String!
    
    public func valid() -> Bool {
        return sharingGroupUUID != nil && masterVersion != nil
    }
}

public class RemoveSharingGroupResponse : ResponseMessage, MasterVersionUpdateResponse {
    public var masterVersionUpdate: MasterVersionInt?
    
    public var responseType: ResponseType {
        return .json
    }
}
