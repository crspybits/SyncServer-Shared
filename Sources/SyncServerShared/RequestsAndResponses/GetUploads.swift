//
//  GetUploads.swift
//  Server
//
//  Created by Christopher Prince on 2/18/17.
//
//

import Foundation

// Request an index of file uploads (UploadFile) and upload deletions (UploadDeleletion) -- queries the meta data on the sync server. The uploads are specific both to the user and the deviceUUID of the user.

public class GetUploadsRequest : RequestMessage {
    // MARK: Properties for use in request message.

    public var sharingGroupUUID: String!

    public func valid() -> Bool {
        return sharingGroupUUID != nil
    }
}

public class GetUploadsResponse : ResponseMessage {
    public var responseType: ResponseType {
        return .json
    }
    
    // FileInfo objects don't contain `cloudStorageType`.
    public var uploads:[FileInfo]?
}
