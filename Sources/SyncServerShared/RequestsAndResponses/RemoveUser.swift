//
//  RemoveUser.swift
//  Server
//
//  Created by Christopher Prince on 12/23/16.
//
//

import Foundation

public class RemoveUserRequest : RequestMessage {
    required public init() {}
    
    // No specific user info is required here because the HTTP auth headers are used to identify the user to be removed. i.e., for now a user can only remove themselves.

    public func valid() -> Bool {
        return true
    }
}

public class RemoveUserResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .json
    }
}
