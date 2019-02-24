//
//  DoneUploads.swift
//  Server
//
//  Created by Christopher Prince on 1/21/17.
//
//

import Foundation

// As part of normal processing, increments the current master version for the sharing group. Calling DoneUploads a second time (immediately after the first) results in 0 files being transferred. i.e., `numberUploadsTransferred` will be 0 for the result of the second operation. This is not considered an error, and the masterVersion is still incremented in this case.
// This operation optionally enables a sharing group update. This provides a means for the sharing group update to not to be queued on the server.
// And it optionally allows for sending a push notification to members of the sharing group.
public class DoneUploadsRequest : RequestMessage, MasterVersionUpdateRequest {
    // MARK: Properties for use in request message.
    
    // Overall version for files for the specific sharing group; assigned by the server.
    public var masterVersion:MasterVersionInt!

    public var sharingGroupUUID: String!
    
#if DEBUG
    // Give a time value in seconds -- after the lock is obtained, the server for sleep for this lock to test locking operation.
    public var testLockSync:Int32?
#endif

    // Optionally perform a sharing group update-- i.e., change the sharing group's name as part of DoneUploads.
    public var sharingGroupName: String?
    
    // Optionally, send a push notification to all members of the sharing group (except for the sender) on a successful DoneUploads. The text of a message for a push notification is application specific and so needs to come from the client.
    public var pushNotificationMessage: String?
    
    public func valid() -> Bool {
        return sharingGroupUUID != nil && masterVersion != nil
    }
}

public class DoneUploadsResponse : ResponseMessage, MasterVersionUpdateResponse {
    public var responseType: ResponseType {
        return .json
    }
    
    // There are two possible non-error responses to DoneUploads:
    
    // 1) On successful operation, this gives the number of uploads entries transferred to the FileIndex.
    public var numberUploadsTransferred:Int32?
    
    // 2) If the master version for the sharing group on the server had been previously incremented to a value different than the masterVersion value in the request, this key will be present in the response-- with the new value of the master version. The doneUploads operation was not attempted in this case.
    public var masterVersionUpdate:MasterVersionInt?
    
    // If present, this reports an error situation on the server. Can only occur if there were pending UploadDeletion's.
    public var numberDeletionErrors:Int32?
}
