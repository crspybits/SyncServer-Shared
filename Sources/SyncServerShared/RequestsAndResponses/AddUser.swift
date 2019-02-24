//
//  AddUser.swift
//  Server
//
//  Created by Christopher Prince on 11/26/16.
//
//

import Foundation

public class AddUserRequest : RequestMessage {
    required public init() {}

    // A root-level folder in the cloud file service. This is only used by some of the cloud file servces. E.g., Google Drive. It's not used by Dropbox.
    public var cloudFolderName:String?
    public static let maxCloudFolderNameLength = 256
    
    // You can optionally give the initial sharing group, created for the user, a name.
    public var sharingGroupName: String?
    
    public var sharingGroupUUID:String!
    
    public func valid() -> Bool {
        return sharingGroupUUID != nil
    }
    
    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try RequestMessageDecoder.decode(AddUserRequest.self, from: dictionary)
    }
}

public class AddUserResponse : ResponseMessage {
    required public init() {}

    // Present only as means to help clients uniquely identify users. This is *never* passed back to the server. This id is unique across all users and is not specific to any sign-in type (e.g., Google).
    public var userId:UserId!
    
    public var responseType: ResponseType {
        return .json
    }
}
