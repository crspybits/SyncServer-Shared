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
    public let requestMessageType: RequestMessage.Type
    public let authenticationLevel:AuthenticationLevel
    
    // Does the user have the mimimum required permissions to perform the endpoint action?
    public let minPermission:Permission!
    
    // These specify the need for a short duration lock on the operation. Only endpoints that have request messages that include a sharingGroupId can set this to true.
    public static let sharingGroupIdKey = "sharingGroupId"
    public let needsLock:Bool
    
    // For requests that adopt the MasterVersionUpdateRequest/MasterVersionUpdateResponse protocol.
    public static let masterVersionKey = "masterVersion"
    public static let masterVersionUpdateKey = "masterVersionUpdate"

    // Don't put a trailing "/" on the pathName.
    public init(_ pathName:String, method:ServerHTTPMethod, messageType: RequestMessage.Type, authenticationLevel:AuthenticationLevel = .secondary, needsLock:Bool = false, minPermission: Permission = .read) {

        assert(pathName.count > 0 && pathName.last != "/")
        
        self.pathName = pathName
        self.method = method
        self.requestMessageType = messageType
        self.authenticationLevel = authenticationLevel
        self.needsLock = needsLock
        self.minPermission = minPermission
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
    
    // No authentication required because this doesn't do any processing within the server-- just a check to ensure the server is running.
    public static let healthCheck = ServerEndpoint("HealthCheck", method: .get, messageType: HealthCheckRequest.self, authenticationLevel: .none)

    // MARK: Users
    
#if DEBUG
    public static let checkPrimaryCreds = ServerEndpoint("CheckPrimaryCreds", method: .get, messageType: CheckPrimaryCredsRequest.self, authenticationLevel: .primary)
#endif

    public static let checkCreds = ServerEndpoint("CheckCreds", method: .get, messageType: CheckCredsRequest.self)
    
    // This creates a "root" owning user account for a sharing group of users. The user must not exist yet on the system.
    // Only primary authentication because this method is used to add a user into the database (i.e., it creates secondary authentication).
    public static let addUser = ServerEndpoint("AddUser", method: .post, messageType: AddUserRequest.self, authenticationLevel: .primary)

    // Removes the calling user from the system.
    public static let removeUser = ServerEndpoint("RemoveUser", method: .post, messageType: RemoveUserRequest.self)
    
    // MARK: Files
    
    // The Index serves as a kind of snapshot of the files and sharing groups on the server for the calling app. Not holding a lock to snapshot files because caller may not give a sharing group id.
    public static let index = ServerEndpoint("Index", method: .get, messageType: IndexRequest.self)
    
    public static let uploadFile = ServerEndpoint("UploadFile", method: .post, messageType: UploadFileRequest.self, minPermission: .write)
    
    // Useful if only the app meta data has changed, so you don't have to re-upload the entire file.
    public static let uploadAppMetaData = ServerEndpoint("UploadAppMetaData", method: .post, messageType: UploadAppMetaDataRequest.self, minPermission: .write)
    
    // Any time we're doing an operation constrained to the current masterVersion, holding the lock seems like a good idea.
    public static let uploadDeletion = ServerEndpoint("UploadDeletion", method: .delete, messageType: UploadDeletionRequest.self, needsLock:true, minPermission: .write)

    // TODO: *0* See also [1] in FileControllerTests.swift.
    // Seems unlikely that the collection of uploads will change while we are getting them (because they are specific to the userId and the deviceUUID), but grab the lock just in case.
    public static let getUploads = ServerEndpoint("GetUploads", method: .get, messageType: GetUploadsRequest.self, needsLock:true, minPermission: .write)
    
    // Not using `needsLock` property here-- but doing the locking internally to the method: Because we have to access cloud storage to deal with upload deletions.
    public static let doneUploads = ServerEndpoint("DoneUploads", method: .post, messageType: DoneUploadsRequest.self, minPermission: .write)

    public static let downloadFile = ServerEndpoint("DownloadFile", method: .get, messageType: DownloadFileRequest.self)
    
    // Useful if only the app meta data has changed, so you don't have to re-download the entire file.
    public static let downloadAppMetaData = ServerEndpoint("DownloadAppMetaData", method: .get, messageType: DownloadAppMetaDataRequest.self)
    
    // MARK: Sharing
    
    // I'm marking this as needing a lock to make sure, at least, that while we're doing the inviting no one deletes the sharing group.
    public static let createSharingInvitation = ServerEndpoint("CreateSharingInvitation", method: .post, messageType: CreateSharingInvitationRequest.self, needsLock: true, minPermission: .admin)
    
    // This creates a sharing user account. The user must not exist yet on the system.
    // Only primary authentication because this method is used to add a user into the database (i.e., it creates secondary authentication).
    public static let redeemSharingInvitation = ServerEndpoint("RedeemSharingInvitation", method: .post, messageType: RedeemSharingInvitationRequest.self, authenticationLevel: .primary)

    public static let createSharingGroup = ServerEndpoint("CreateSharingGroup", method: .post, messageType: CreateSharingGroupRequest.self, authenticationLevel: .secondary, minPermission: .admin)

    public static let updateSharingGroup = ServerEndpoint("UpdateSharingGroup", method: .patch, messageType: UpdateSharingGroupRequest.self, authenticationLevel: .secondary, needsLock: true, minPermission: .admin)

    public static let removeSharingGroup = ServerEndpoint("RemoveSharingGroup", method: .post, messageType: RemoveSharingGroupRequest.self, authenticationLevel: .secondary, needsLock: true, minPermission: .admin)

    public static let getSharingGroupUsers = ServerEndpoint("GetSharingGroupUsers", method: .get, messageType: GetSharingGroupUsersRequest.self, authenticationLevel: .secondary, needsLock: true, minPermission: .read)

    public static let session = ServerEndpoints()
    
    private init() {
        all.append(contentsOf: [
            ServerEndpoints.healthCheck,
        
            ServerEndpoints.addUser, ServerEndpoints.checkCreds, ServerEndpoints.removeUser,
        
            ServerEndpoints.index, ServerEndpoints.uploadFile, ServerEndpoints.doneUploads, ServerEndpoints.getUploads, ServerEndpoints.uploadDeletion,
        
            ServerEndpoints.createSharingInvitation,
            ServerEndpoints.redeemSharingInvitation,
            ServerEndpoints.createSharingGroup, ServerEndpoints.removeSharingGroup,
            ServerEndpoints.updateSharingGroup, ServerEndpoints.getSharingGroupUsers])
    }
}
