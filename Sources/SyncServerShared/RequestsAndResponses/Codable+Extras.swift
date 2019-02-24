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

/* Example constructor usage:
    let decoder = RequestMessageDecoder() { decoder, data in
        try decoder.decode(IndexRequest.self, from: data)
    }
*/
public class RequestMessageDecoder {
    let convert: ((JSONDecoder, Data) throws -> (RequestMessage))
    
    public init(convert: @escaping ((JSONDecoder, Data) throws -> (RequestMessage))) {
        self.convert = convert
    }
    
    let jsonDecoder:JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = DateExtras.getDateFormatter(format: .DATETIME)
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()
    
    /// Decodes given Decodable type from given array or dictionary
    public func decode(from json: Any) throws -> RequestMessage {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        return try convert(jsonDecoder, jsonData)
    }
}
