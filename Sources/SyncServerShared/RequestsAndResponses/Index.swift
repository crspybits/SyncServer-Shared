//
//  Index.swift
//  Server
//
//  Created by Christopher Prince on 1/28/17.
//
//

import Foundation
import Gloss

#if SERVER
import Kitura
import PerfectLib
#endif

// Returns a list of all sharing groups that the user is a member of.
// And optionally request an index of all files that have been uploaded with UploadFile and committed using DoneUploads for the sharing group -- queries the meta data on the sync server.

public class IndexRequest : NSObject, RequestMessage {
#if DEBUG
    // Give a time value in seconds -- the server for sleep to test failure of API calls.
    public static let testServerSleepKey = "testServerSleep"
    public var testServerSleep:Int32?
#endif

    // Give this if you want the index of files for a sharing group.
    public var sharingGroupId: SharingGroupId?
 
    public required init?(json: JSON) {
        super.init()
#if DEBUG
        self.testServerSleep = Decoder.decode(int32ForKey: IndexRequest.testServerSleepKey)(json)
#endif
        self.sharingGroupId = Decoder.decode(int64ForKey: ServerEndpoint.sharingGroupIdKey)(json)

#if SERVER
        Log.info(message: "IndexRequest.testServerSleep: \(String(describing: testServerSleep))")
#endif

        if !nonNilKeysHaveValues(in: json) {
#if SERVER
            Log.debug(message: "json was: \(json)")
#endif
            return nil
        }
    }

    public func toJSON() -> JSON? {
        var result = [JSON?]()
        
#if DEBUG
        result += [IndexRequest.testServerSleepKey ~~> self.testServerSleep]
#endif
        result += [ServerEndpoint.sharingGroupIdKey ~~> self.sharingGroupId]
        
        return jsonify(result)
    }
    
#if SERVER
    public required convenience init?(request: RouterRequest) {
        self.init(json: request.queryParameters)
    }
#endif
    
    public func allKeys() -> [String] {
#if DEBUG
        return self.nonNilKeys() + [IndexRequest.testServerSleepKey]
#else
        return self.nonNilKeys()
#endif
    }
    
    public func nonNilKeys() -> [String] { return [
        ServerEndpoint.sharingGroupIdKey]
    }
}

public class IndexResponse : ResponseMessage {
    public var responseType: ResponseType {
        return .json
    }
    
    // The following two are provided iff you gave a sharing group id in the request.
    
    // The master version for the requested sharing group.
    public static let masterVersionKey = "masterVersion"
    public var masterVersion:MasterVersionInt?
    
    // The files in the requested sharing group.
    public static let fileIndexKey = "fileIndex"
    public var fileIndex:[FileInfo]?
    
    // The sharing groups in which this user is a member.
    public static let sharingGroupsKey = "sharingGroups"
    public var sharingGroups:[SharingGroup]!
    
    public required init?(json: JSON) {
        self.masterVersion = Decoder.decode(int64ForKey: IndexResponse.masterVersionKey)(json)
        self.fileIndex = IndexResponse.fileIndexKey <~~ json
        self.sharingGroups = IndexResponse.sharingGroupsKey <~~ json
    }
    
    public convenience init?() {
        self.init(json:[:])
    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            IndexResponse.masterVersionKey ~~> self.masterVersion,
            IndexResponse.fileIndexKey ~~> self.fileIndex,
            IndexResponse.sharingGroupsKey ~~> self.sharingGroups
        ])
    }
}

