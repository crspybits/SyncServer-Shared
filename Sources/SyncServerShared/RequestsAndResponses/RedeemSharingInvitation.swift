//
//  RedeemSharingInvitation.swift
//  Server
//
//  Created by Christopher Prince on 4/12/17.
//
//

import Foundation

public class RedeemSharingInvitationRequest : RequestMessage {
    required public init() {}

    // No master version here: The client doesn't yet have information about relevant sharing group that it needs to keep up to date. So, why bother?
    
    public var sharingInvitationUUID:String!

    // This must be present when redeeming an invitation: a) using an owning account, and b) that owning account type needs a cloud storage folder (e.g., Google Drive).
    public var cloudFolderName:String?
    
    public func valid() -> Bool {
        return sharingInvitationUUID != nil
    }
}

public class RedeemSharingInvitationResponse : ResponseMessage {
    required public init() {}

    // Present only as means to help clients uniquely identify users. This is *never* passed back to the server. This id is unique across all users and is not specific to any sign-in type (e.g., Google).
    public var userId:UserId!
    
    public var sharingGroupUUID: String!
    
    public var responseType: ResponseType {
        return .json
    }
}
