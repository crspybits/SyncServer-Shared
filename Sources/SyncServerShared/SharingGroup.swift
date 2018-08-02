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


