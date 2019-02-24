//
//  DownloadAppMetaData.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 3/23/18.
//

import Foundation

public class DownloadAppMetaDataRequest : RequestMessage {
    // MARK: Properties for use in request message.
    
    public var fileUUID:String!
    
    // This must indicate the current version in the FileIndex. Not allowing this to be nil because that would mean the appMetaData on the server would be nil, and what's the point of asking for that?
    public var appMetaDataVersion:AppMetaDataVersionInt!
    
    // Overall version for files for the specific user; assigned by the server.
    public var masterVersion:MasterVersionInt!
    
    public var sharingGroupUUID: String!
    
    public func valid() -> Bool {
        return fileUUID != nil && appMetaDataVersion != nil && masterVersion != nil && sharingGroupUUID != nil
    }
}

public class DownloadAppMetaDataResponse : ResponseMessage {
    public var responseType: ResponseType {
        return .json
    }
    
    // Just the appMetaData contents.
    public var appMetaData:String?
    
    // If the master version for the user on the server has been incremented, this key will be present in the response-- with the new value of the master version. The download was not attempted in this case.
    public var masterVersionUpdate:MasterVersionInt?
}
