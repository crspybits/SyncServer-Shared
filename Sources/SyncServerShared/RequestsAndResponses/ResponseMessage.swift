//
//  ResponseMessage.swift
//  Server
//
//  Created by Christopher Prince on 11/27/16.
//
//

import Foundation
import Gloss

public enum ResponseType {
case json
case data(data: Data?)

// The response fields are the value of an HTTP header key.
case header
}

public protocol ResponseMessage : Glossy {
    init?(json: JSON)
    var responseType:ResponseType {get}
}

