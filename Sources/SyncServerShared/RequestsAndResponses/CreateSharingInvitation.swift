//
//  CreateSharingInvitation.swift
//  Server
//
//  Created by Christopher Prince on 4/9/17.
//
//

import Foundation

public class CreateSharingInvitationRequest : RequestMessage {
    required public init() {}

    public var permission:Permission!
    
    // Social acceptance means the inviting user allows hosting of accepting user's files.
    public var allowSocialAcceptance: Bool = true
    
    // Number of people allowed to receive/accept invitation. >= 1
    public var numberOfAcceptors:UInt = 1
    
    // The sharing group to which user(s) are being invited. The inviting user must have admin permissions in this group.
    public var sharingGroupUUID:String!
    
    private enum CodingKeys: String, CodingKey {
        case permission
        case allowSocialAcceptance
        case numberOfAcceptors
        case sharingGroupUUID
    }
    
    public func valid() -> Bool {
        return sharingGroupUUID != nil && permission != nil && numberOfAcceptors >= 1
    }
    
    private static func customConversions(dictionary: [String: Any]) -> [String: Any] {
        var result = dictionary
        
        // Unfortunate customization due to https://bugs.swift.org/browse/SR-5249
        MessageDecoder.convertBool(key: CreateSharingInvitationRequest.CodingKeys.allowSocialAcceptance.rawValue, dictionary: &result)
        return result
    }

    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try MessageDecoder.decode(CreateSharingInvitationRequest.self, from: customConversions(dictionary: dictionary))
    }
}

public class CreateSharingInvitationResponse : ResponseMessage {
    required public init() {}

    public var sharingInvitationUUID:String!

    public var responseType: ResponseType {
        return .json
    }
    
    public static func decode(_ dictionary: [String: Any]) throws -> CreateSharingInvitationResponse {
        return try MessageDecoder.decode(CreateSharingInvitationResponse.self, from: dictionary)
    }
}
