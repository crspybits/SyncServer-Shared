//
//  CheckPrimaryCreds.swift
//  Server
//
//  Created by Christopher Prince on 12/17/16.
//
//

import Foundation

public class CheckPrimaryCredsRequest : RequestMessage {
    public func valid() -> Bool {
        return true
    }
}

public class CheckPrimaryCredsResponse : ResponseMessage {
    public var responseType: ResponseType {
        return .json
    }
}
