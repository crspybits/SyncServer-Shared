//
//  SharingGroup.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 8/1/18.
//

import Foundation
import Gloss

#if SERVER
import Kitura
#endif

public class SharingGroup : Gloss.Encodable, Gloss.Decodable {
    public var sharingGroupId: SharingGroupId?
    
    // The sharing group name is just meta data and is not required to be distinct from other sharing group names. Not making it required either-- some app use cases might not need it.
    public static let sharingGroupNameKey = "sharingGroupName"
    public var sharingGroupName: String?
    
    // Has this sharing group been deleted?
    public static let deletedKey = "deleted"
    public var deleted: Bool?
    
    required public init?(json: JSON) {
        self.sharingGroupName = SharingGroup.sharingGroupNameKey <~~ json
        self.sharingGroupId = Decoder.decode(int64ForKey: ServerEndpoint.sharingGroupIdKey)(json)
        self.deleted = SharingGroup.deletedKey <~~ json
    }
    
    public convenience init?() {
        self.init(json:[:])
    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            SharingGroup.sharingGroupNameKey ~~> self.sharingGroupName,
            ServerEndpoint.sharingGroupIdKey ~~> self.sharingGroupId,
            SharingGroup.deletedKey ~~> self.deleted
        ])
    }
}

public class SharingGroupUser : Gloss.Encodable, Gloss.Decodable {
    public static let nameKey = "name"
    public var name: String!

    required public init?(json: JSON) {
        self.name = SharingGroupUser.nameKey <~~ json
    }
    
    public convenience init?() {
        self.init(json:[:])
    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            SharingGroupUser.nameKey ~~> self.name
        ])
    }
}

public protocol MasterVersionUpdateRequest: RequestMessage {
    var masterVersion:MasterVersionInt! {get}
}

public protocol MasterVersionUpdateResponse: ResponseMessage {
    // If the master version for the sharing group on the server had been previously incremented to a value different than the masterVersion value in the request, this key will be present in the response-- with the new value of the master version. The requested operation was not attempted in this case.
    var masterVersionUpdate:MasterVersionInt? {get set}
}

