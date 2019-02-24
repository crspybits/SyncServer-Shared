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
    
    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try RequestMessageDecoder.decode(CheckPrimaryCredsRequest.self, from: dictionary)
    }
}

public class CheckPrimaryCredsResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .json
    }
}
