//
//  Codable+Extras.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 2/24/19.
//

import Foundation
#if SERVER
import LoggerAPI
#endif

public extension Encodable {
    public var toDictionary: [String: Any]? {
        let encoder = JSONEncoder()
        let formatter = DateExtras.getDateFormatter(format: .DATETIME)
        encoder.dateEncodingStrategy = .formatted(formatter)
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

public class MessageDecoder {
    public static func decode<T>(_ type: T.Type, from json: Any) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        let decoder = JSONDecoder()
        let formatter = DateExtras.getDateFormatter(format: .DATETIME)
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        do {
            let result = try decoder.decode(type, from: jsonData)
            return result
        } catch (let error) {
            #if SERVER
                Log.error("Error decoding: \(error)")
            #endif
            throw error
        }
    }
}
