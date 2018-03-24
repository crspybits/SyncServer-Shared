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
    var appMetaData:String! {get}
    var appMetaDataVersion:AppMetaDataVersionInt! {get}
}

public class UploadAppMetaDataRequest : NSObject, RequestMessage, UploadAppMetaData {
    // MARK: Properties for use in request message.
    
    // Assigned by client.
    public static let fileUUIDKey = "fileUUID"
    public var fileUUID:String!
    
    public static let appMetaDataKey = "appMetaData"
    public var appMetaData:String!

    // Must be 0 (for new appMetaData) or N+1 where N is the current version of the appMetaData on the server. Each time you change the appMetaData field above and upload it, you must increment this version.
    public static let appMetaDataVersionKey = "appMetaDataVersion"
    public var appMetaDataVersion:AppMetaDataVersionInt!
    
    // Overall version for files for the specific owning user; assigned by the server.
    public static let masterVersionKey = "masterVersion"
    public var masterVersion:MasterVersionInt!
    
    public func nonNilKeys() -> [String] {
        return [UploadFileRequest.fileUUIDKey, UploadFileRequest.appMetaDataKey, UploadFileRequest.appMetaDataVersionKey, UploadFileRequest.masterVersionKey]
    }
    
    public func allKeys() -> [String] {
        return self.nonNilKeys()
    }
    
    public required init?(json: JSON) {
        super.init()
        
        self.fileUUID = UploadFileRequest.fileUUIDKey <~~ json
        self.appMetaData = UploadFileRequest.appMetaDataKey <~~ json
        self.appMetaDataVersion = Decoder.decode(int32ForKey: UploadFileRequest.appMetaDataVersionKey)(json)
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
            UploadFileRequest.appMetaDataVersionKey ~~> self.appMetaDataVersion,
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

