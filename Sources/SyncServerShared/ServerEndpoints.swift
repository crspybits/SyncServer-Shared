//
//  ServerEndpoints.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 6/21/18.
//

import Foundation

public struct ServerEndpoint {
    public let pathName:String // Doesn't have preceding "/"
    public let method:ServerHTTPMethod
    public let requestMessageDecoder: RequestMessageDecoder
    public let authenticationLevel:AuthenticationLevel
    
    // MARK: The following are for endpoints operating with respect to a specific sharing group. Their requests must have a sharingGroupUUID.
    
    public static let sharingGroupUUIDKey = "sharingGroupUUID"

    // For requests that adopt the MasterVersionUpdateRequest/MasterVersionUpdateResponse protocol.
    public static let masterVersionKey = "masterVersion"
    public static let masterVersionUpdateKey = "masterVersionUpdate"

    public let sharing: ServerEndpoints.Sharing?

    // Don't put a trailing "/" on the pathName.
    public init(_ pathName:String, method:ServerHTTPMethod, authenticationLevel:AuthenticationLevel = .secondary, sharing: ServerEndpoints.Sharing? = nil, requestMessageDecoder: RequestMessageDecoder) {

        assert(pathName.count > 0 && pathName.last != "/")
        
        self.pathName = pathName
        self.method = method
        self.authenticationLevel = authenticationLevel
        self.sharing = sharing
        self.requestMessageDecoder = requestMessageDecoder
    }
    
    public var path:String { // With prefix "/"
        return "/" + pathName
    }
    
    public var pathWithSuffixSlash:String { // With prefix "/" and suffix "/"
        return path + "/"
    }
}

/* When adding an endpoint:
    a) add it as a `public static let`
    b) add it in the `all` list in the `init`, and
    c) add it into ServerRoutes.swift in the Server repo.
*/
public class ServerEndpoints {
    public private(set) var all = [ServerEndpoint]()
    
    public struct Sharing {
        // Needs a short duration lock on the sharing group for the endpoint operation?
        public let needsLock:Bool
        
        // Does the user have the mimimum required permissions on the sharing group to perform the endpoint action? Set this to nil if no permissions are required.
        public let minPermission:Permission?
        
        init(needsLock:Bool, minPermission:Permission? = .read) {
            self.needsLock = needsLock
            self.minPermission = minPermission
        }
    }
    
    // No authentication required because this doesn't do any processing within the server-- just a check to ensure the server is running.
    public static let healthCheck = ServerEndpoint("HealthCheck", method: .get, authenticationLevel: .none, requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(HealthCheckRequest.self, from: data)
            })

    // MARK: Users
    
#if DEBUG
    public static let checkPrimaryCreds = ServerEndpoint("CheckPrimaryCreds", method: .get, authenticationLevel: .primary, requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(CheckPrimaryCredsRequest.self, from: data)
            })
#endif

    public static let checkCreds = ServerEndpoint("CheckCreds", method: .get, requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(CheckCredsRequest.self, from: data)
            })
    
    // This creates a "root" owning user account for a sharing group of users. The user must not exist yet on the system.
    // Only primary authentication because this method is used to add a user into the database (i.e., it creates secondary authentication).
    public static let addUser = ServerEndpoint("AddUser", method: .post, authenticationLevel: .primary, requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(AddUserRequest.self, from: data)
            })

    // Removes the calling user from the system.
    public static let removeUser = ServerEndpoint("RemoveUser", method: .post, requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(RemoveUserRequest.self, from: data)
            })
    
    // MARK: Files
    
    // The Index serves as a kind of snapshot of the files and sharing groups on the server for the calling app. Not specifying a lock is held at this level because caller may not give a sharing group uuid. If the sharing group uuid is given, holds lock within the controller.
    public static let index = ServerEndpoint("Index", method: .get, requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(IndexRequest.self, from: data)
            })
    
    public static let uploadFile = ServerEndpoint("UploadFile", method: .post, sharing: Sharing(needsLock: false, minPermission: .write), requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(UploadFileRequest.self, from: data)
            })
    
    // Useful if only the app meta data has changed, so you don't have to re-upload the entire file.
    public static let uploadAppMetaData = ServerEndpoint("UploadAppMetaData", method: .post, sharing: Sharing(needsLock: false, minPermission: .write), requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(UploadAppMetaDataRequest.self, from: data)
            })
    
    public static let uploadDeletion = ServerEndpoint("UploadDeletion", method: .delete, sharing: Sharing(needsLock: false, minPermission: .write), requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(UploadDeletionRequest.self, from: data)
            })

    // TODO: *0* See also [1] in FileControllerTests.swift.
    // Seems unlikely that the collection of uploads will change while we are getting them (because they are specific to the userId and the deviceUUID), but grab the lock just in case.
    public static let getUploads = ServerEndpoint("GetUploads", method: .get, sharing: Sharing(needsLock: true, minPermission: .write), requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(GetUploadsRequest.self, from: data)
            })
    
    // Not using `needsLock` property here-- but doing the locking internally to the method: Because we have to access cloud storage to deal with upload deletions.
    public static let doneUploads = ServerEndpoint("DoneUploads", method: .post, sharing: Sharing(needsLock: false, minPermission: .write), requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(DoneUploadsRequest.self, from: data)
            })

    public static let downloadFile = ServerEndpoint("DownloadFile", method: .get, sharing: Sharing(needsLock: false, minPermission: .read), requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(DownloadFileRequest.self, from: data)
            })
    
    // Useful if only the app meta data has changed, so you don't have to re-download the entire file.
    public static let downloadAppMetaData = ServerEndpoint("DownloadAppMetaData", method: .get, sharing: Sharing(needsLock: false, minPermission: .read), requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(DownloadAppMetaDataRequest.self, from: data)
            })
    
    // MARK: Sharing
    
    public static let createSharingInvitation = ServerEndpoint("CreateSharingInvitation", method: .post, sharing: Sharing(needsLock: true, minPermission: .admin), requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(CreateSharingInvitationRequest.self, from: data)
            })
    
    // This creates a sharing user account. The user must not exist yet on the system.
    // Only primary authentication because this method is used to add a user into the database (i.e., it creates secondary authentication).
    // This is locked in the server controller code-- we don't have a sharingGroupUUID in the request parameters.
    public static let redeemSharingInvitation = ServerEndpoint("RedeemSharingInvitation", method: .post, authenticationLevel: .primary, requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(RedeemSharingInvitationRequest.self, from: data)
            })

    // This doesn't need a lock-- it's for a new sharing group. However, I'm making sure in the implementation that the user owns cloud storage-- as a form of "permission".
    public static let createSharingGroup = ServerEndpoint("CreateSharingGroup", method: .post, authenticationLevel: .secondary, requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(CreateSharingGroupRequest.self, from: data)
            })

    public static let updateSharingGroup = ServerEndpoint("UpdateSharingGroup", method: .patch, authenticationLevel: .secondary, sharing: Sharing(needsLock: true, minPermission: .admin), requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(UpdateSharingGroupRequest.self, from: data)
            })

    // Remove sharing group from the system.
    public static let removeSharingGroup = ServerEndpoint("RemoveSharingGroup", method: .post, authenticationLevel: .secondary, sharing: Sharing(needsLock: true, minPermission: .admin), requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(RemoveSharingGroupRequest.self, from: data)
            })

    // Removes the calling user from the sharing group given in the request.
    public static let removeUserFromSharingGroup = ServerEndpoint("RemoveUserFromSharingGroup", method: .post, authenticationLevel: .secondary, sharing: Sharing(needsLock: true, minPermission: nil), requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(RemoveUserFromSharingGroupRequest.self, from: data)
            })
    
    // MARK: Push Notifications
    
    public static let registerPushNotificationToken = ServerEndpoint("RegisterPushNotificationToken", method: .post, authenticationLevel: .secondary, requestMessageDecoder:
            RequestMessageDecoder() { decoder, data in
                try decoder.decode(RegisterPushNotificationTokenRequest.self, from: data)
            })

    public static let session = ServerEndpoints()
    
    private init() {
        all.append(contentsOf: [
            ServerEndpoints.healthCheck,
        
            ServerEndpoints.addUser, ServerEndpoints.checkCreds, ServerEndpoints.removeUser,
        
            ServerEndpoints.index, ServerEndpoints.uploadFile, ServerEndpoints.doneUploads, ServerEndpoints.getUploads, ServerEndpoints.uploadDeletion,
        
            ServerEndpoints.createSharingInvitation,
            ServerEndpoints.redeemSharingInvitation,
            ServerEndpoints.createSharingGroup, ServerEndpoints.removeSharingGroup,
            ServerEndpoints.updateSharingGroup,
            ServerEndpoints.removeUserFromSharingGroup,
            
            ServerEndpoints.registerPushNotificationToken])
    }
}
