//
//  JSONExtras.swift
//  Server
//
//  Created by Christopher Prince on 7/18/17.
//

import Foundation
import LoggerAPI

public class JSONExtras {
    public static func toJSONString(dict:[String:Any]) -> String? {
        var data:Data!
        
        do {
            try data = JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: UInt(0)))
        } catch (let error) {
            Log.error("Could not convert json to data: \(error)")
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
