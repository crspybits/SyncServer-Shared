//
//  CreateSharingInvitation.swift
//  Server
//
//  Created by Christopher Prince on 4/9/17.
//
//

import Foundation

public class CreateSharingInvitationRequest : RequestMessage {
    public var permission:Permission!
    
    // The sharing group to which a user is being invited. The inviting user must have admin permissions in this group.
    public var sharingGroupUUID:String!
    
    public func valid() -> Bool {
        return sharingGroupUUID != nil && permission != nil
    }
}

public class CreateSharingInvitationResponse : ResponseMessage {
    public var sharingInvitationUUID:String!

    public var responseType: ResponseType {
        return .json
    }
}
