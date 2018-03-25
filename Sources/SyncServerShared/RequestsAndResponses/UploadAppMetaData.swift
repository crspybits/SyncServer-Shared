//
//  UploadAppMetaData.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 3/23/18.
//

import Foundation
import Gloss

#if SERVER
import PerfectLib
import Kitura
#endif

public protocol UploadAppMetaData {
    var appMetaData:AppMetaData! {get}
}

public struct AppMetaData: Gloss.Encodable, Gloss.Decodable {
    public func toJSON() -> JSON? {
        if version == nil || contents == nil {
            return nil
        }
        
        return jsonify([
            AppMetaData.versionKey ~~> self.version,
            AppMetaData.contentsKey ~~> self.contents
        ])
    }

    public init?(json: JSON) {
        version = Decoder.decode(int32ForKey: AppMetaData.versionKey)(json)
        contents = AppMetaData.contentsKey <~~ json
        
        if version == nil || contents == nil {
            return nil
        }
    }

    public static let contentsKey = "appMetaDataContents"
    public static let versionKey = "appMetaDataVersion"
    
    // Must be 0 (for new appMetaData) or N+1 where N is the current version of the appMetaData on the server. Each time you change the contents field and upload it, you must increment this version.
    public let version: AppMetaDataVersionInt!
    
    public let contents: String!
}

public class UploadAppMetaDataRequest : NSObject, RequestMessage, UploadAppMetaData {
    // MARK: Properties for use in request message.
    
    // Assigned by client.
    public static let fileUUIDKey = "fileUUID"
    public var fileUUID:String!
    
    public static let appMetaDataKey = "appMetaData"
    public var appMetaData:AppMetaData!
    
    // Overall version for files for the specific owning user; assigned by the server.
    public static let masterVersionKey = "masterVersion"
    public var masterVersion:MasterVersionInt!
    
    public func nonNilKeys() -> [String] {
        return [UploadFileRequest.fileUUIDKey, UploadFileRequest.masterVersionKey, UploadFileRequest.appMetaDataKey]
    }
    
    public func allKeys() -> [String] {
        return self.nonNilKeys()
    }
    
    public required init?(json: JSON) {
        super.init()
        
        self.fileUUID = UploadFileRequest.fileUUIDKey <~~ json
        self.appMetaData = UploadFileRequest.appMetaDataKey <~~ json
        self.masterVersion = Decoder.decode(int64ForKey: UploadFileRequest.masterVersionKey)(json)
        
#if SERVER
        if !self.propertiesHaveValues(propertyNames: self.nonNilKeys()) {
            return nil
        }
#endif

        guard let _ = NSUUID(uuidString: self.fileUUID) else {
            return nil
        }
    }

#if SERVER
    public required convenience init?(request: RouterRequest) {
        self.init(json: request.queryParameters)
    }
#endif
    
    public func toJSON() -> JSON? {
        return jsonify([
            UploadFileRequest.fileUUIDKey ~~> self.fileUUID,
            UploadFileRequest.appMetaDataKey ~~> self.appMetaData,
            UploadFileRequest.masterVersionKey ~~> self.masterVersion,
        ])
    }
}

public class UploadAppMetaDataResponse : ResponseMessage {
    public var responseType: ResponseType {
        return .header
    }
    
    // If the master version for the user on the server has been incremented, this key will be present in the response-- with the new value of the master version. The upload was not attempted in this case.
    public static let masterVersionUpdateKey = "masterVersionUpdate"
    public var masterVersionUpdate:MasterVersionInt?
    
    public required init?(json: JSON) {
        self.masterVersionUpdate = Decoder.decode(int64ForKey: UploadFileResponse.masterVersionUpdateKey)(json)
    }
    
    public convenience init?() {
        self.init(json:[:])
    }
    
    // MARK: - Serialization
    public func toJSON() -> JSON? {

        return jsonify([
            UploadFileResponse.masterVersionUpdateKey ~~> self.masterVersionUpdate,
        ])
    }
}

