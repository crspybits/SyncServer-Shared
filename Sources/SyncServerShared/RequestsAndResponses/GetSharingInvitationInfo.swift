//
//  GetSharingInvitationInfo.swift
//  Server
//
//  Created by Christopher Prince on 4/8/19.
//
//

import Foundation

public class GetSharingInvitationInfoRequest : RequestMessage {
    required public init() {}

    // MARK: Properties for use in request message.

    public var sharingInvitationUUID: String!

    public func valid() -> Bool {
        guard sharingInvitationUUID != nil,
            let _ = NSUUID(uuidString: sharingInvitationUUID) else {
            return false
        }
        
        return true
    }
    
    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try MessageDecoder.decode(GetSharingInvitationInfoRequest.self, from: dictionary)
    }
}

public class GetSharingInvitationInfoResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .json
    }
    
    public var permission:Permission!
    public var allowSocialAcceptance: Bool!
    
    public static func decode(_ dictionary: [String: Any]) throws -> GetSharingInvitationInfoResponse {
        return try MessageDecoder.decode(GetSharingInvitationInfoResponse.self, from: dictionary)
    }
}
