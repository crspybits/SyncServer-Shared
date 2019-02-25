//
//  UploadAppMetaData.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 3/23/18.
//

import Foundation

public struct AppMetaData: Codable, Equatable {
    // Must be 0 (for new appMetaData) or N+1 where N is the current version of the appMetaData on the server. Each time you change the contents field and upload it, you must increment this version.
    public let version: AppMetaDataVersionInt
    
    public let contents: String
    
    public static func ==(lhs: AppMetaData, rhs: AppMetaData) -> Bool {
        return lhs.version == rhs.version && lhs.contents == rhs.contents
    }

    public init(version: AppMetaDataVersionInt, contents: String) {
        self.version = version
        self.contents = contents
    }
}

// Updating the app meta data using this request doesn't change the update date on the file.
public class UploadAppMetaDataRequest : RequestMessage {
    required public init() {}

    // MARK: Properties for use in request message.
    
    // Assigned by client.
    public var fileUUID:String!
    
    public var appMetaData:AppMetaData!
    
    // Overall version for files for the specific owning user; assigned by the server.
    public var masterVersion:MasterVersionInt!
    
    public var sharingGroupUUID:String!
    
    public func valid() -> Bool {
        guard fileUUID != nil && masterVersion != nil && sharingGroupUUID != nil,
            let _ = NSUUID(uuidString: self.fileUUID) else {
            return false
        }
        
        return true
    }
    
    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try MessageDecoder.decode(UploadAppMetaDataRequest.self, from: dictionary)
    }
}

public class UploadAppMetaDataResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .json
    }
    
    // If the master version for the user on the server has been incremented, this key will be present in the response-- with the new value of the master version. The upload was not attempted in this case.
    public var masterVersionUpdate:MasterVersionInt?
    
    public static func decode(_ dictionary: [String: Any]) throws -> UploadAppMetaDataResponse {
        return try MessageDecoder.decode(UploadAppMetaDataResponse.self, from: dictionary)
    }
}

