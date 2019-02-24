//
//  CheckPrimaryCreds.swift
//  Server
//
//  Created by Christopher Prince on 12/17/16.
//
//

import Foundation

public class CheckPrimaryCredsRequest : RequestMessage {
    required public init() {}

    public func valid() -> Bool {
        return true
    }
}

public class CheckPrimaryCredsResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .json
    }
}
