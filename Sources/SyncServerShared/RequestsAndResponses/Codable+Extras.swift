//
//  Codable+Extras.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 2/24/19.
//

import Foundation

public extension Encodable {
    public var toDictionary: [String: Any]? {
        let encoder = JSONEncoder()
        let formatter = DateExtras.getDateFormatter(format: .DATETIME)
        encoder.dateEncodingStrategy = .formatted(formatter)
        
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

public class DictionaryDecoder {
    public init() {}
    
    private let jsonDecoder:JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = DateExtras.getDateFormatter(format: .DATETIME)
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()

    /// Decodes given Decodable type from given array or dictionary
    public func decode<T>(_ type: T.Type, from json: Any) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        return try jsonDecoder.decode(type, from: jsonData)
    }
}
