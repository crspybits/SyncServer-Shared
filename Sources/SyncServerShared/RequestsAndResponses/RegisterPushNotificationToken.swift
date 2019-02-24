//
//  RegisterPushNotificationToken.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 2/6/19.
//

import Foundation

// Enable an app to register a Push Notification token.

public class RegisterPushNotificationTokenRequest : RequestMessage {
    public var pushNotificationToken: String!
    
    public func valid() -> Bool {
        guard pushNotificationToken != nil else {
            return false
        }
        
        return true
    }
}

public class RegisterPushNotificationTokenResponse : ResponseMessage {
    public var responseType: ResponseType {
        return .json
    }
}
