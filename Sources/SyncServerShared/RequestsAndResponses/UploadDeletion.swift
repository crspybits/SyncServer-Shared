//
//  DeleteFile.swift
//  Server
//
//  Created by Christopher Prince on 2/18/17.
//
//

import Foundation

// This places a deletion request in the Upload table on the server. A DoneUploads request is subsequently required to actually perform the deletion in cloud storage.
// An upload deletion can be repeated for the same file: This doesn't cause an error and doesn't duplicate rows in the Upload table.

public class UploadDeletionRequest : RequestMessage, Filenaming {
    required public init() {}

    // The use of the Filenaming protocol here is to support the DEBUG `actualDeletion` parameter.
    
    // MARK: Properties for use in request message.
    
    public var fileUUID:String!
    
    // This must indicate the current version of the file in the FileIndex.
    public var fileVersion:FileVersionInt!
    
    // Overall version for files for the sharing group; assigned by the server.
    public var masterVersion:MasterVersionInt!
    
    public var sharingGroupUUID: String!

#if DEBUG
    // Enable the client to actually delete files-- for testing purposes. The UploadDeletionRequest will not queue the request, but instead deletes from both the FileIndex and from cloud storage.
    public var actualDeletion:Int32? // Should be 0 or non-0; I haven't been able to get Bool to work with Gloss
#endif

    public func valid() -> Bool {
        guard fileUUID != nil && fileVersion != nil && masterVersion != nil && sharingGroupUUID != nil else {
            return false
        }
        
        return true
    }

    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try RequestMessageDecoder.decode(UploadDeletionRequest.self, from: dictionary)
    }
}

public class UploadDeletionResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .json
    }
    
    // If the master version for the user on the server has been incremented, this key will be present in the response-- with the new value of the master version. The upload deletion was not attempted in this case.
    public var masterVersionUpdate:Int64?
}
