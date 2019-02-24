//
//  Codable+Extras.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 2/24/19.
//

import Foundation

public extension Encodable {
    public var toDictionary: [String: Any]? {
        // TODO: Need to set up date encoding.
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

public class DictionaryDecoder {
    // TODO: Need to set up date encoding.
    private let jsonDecoder = JSONDecoder()

    /// Decodes given Decodable type from given array or dictionary
    public func decode<T>(_ type: T.Type, from json: Any) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        return try jsonDecoder.decode(type, from: jsonData)
    }
}
