//
//  DownloadFile.swift
//  Server
//
//  Created by Christopher Prince on 1/29/17.
//
//

import Foundation

public class DownloadFileRequest : RequestMessage {
    required public init() {}

    // MARK: Properties for use in request message.
    
    public var fileUUID:String!
    
    // This must indicate the current version of the file in the FileIndex.
    public var fileVersion:FileVersionInt!
    
    public var sharingGroupUUID:String!
    
    // This must indicate the current version of the app meta data for the file in the FileIndex (or nil if there is none yet).
    public var appMetaDataVersion:AppMetaDataVersionInt?
    
    // Overall version for files for the specific user; assigned by the server.
    public var masterVersion:MasterVersionInt!
    
    public func valid() -> Bool {
        guard fileUUID != nil && fileVersion != nil && masterVersion != nil && sharingGroupUUID != nil, let _ = NSUUID(uuidString: self.fileUUID) else {
            return false
        }
        
        return true
    }
}

public class DownloadFileResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .data(data: data)
    }
    
    public var appMetaData:String?
    
    public var data:Data?
    
    // This can be used by a client to know how to compute the checksum if they upload another version of this file.
    public var cloudStorageType: String!

    // The check sum for the file currently stored in cloud storage. The specific meaning of this value depends on the specific cloud storage system. See `cloudStorageType`. This can be used by clients to assess if there was an error in transmitting the file contents across the network. i.e., does this checksum match what is computed by the client after the file is downloaded?
    public var checkSum:String!
    
    // Did the contents of the file change while it was "at rest" in cloud storage? e.g., a user changed their file directly?
    public var contentsChanged:Bool!
    
    // If the master version for the user on the server has been incremented, this key will be present in the response-- with the new value of the master version. The download was not attempted in this case.
    public var masterVersionUpdate:MasterVersionInt?
    
    // The file was gone and could not be downloaded. The string gives the GoneReason if non-nil, and the data, contentsChanged, and checkSum fields are not given.
    public var gone: String?
}
