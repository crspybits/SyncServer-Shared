//
//  FileIndex.swift
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

// Request an index of all files that have been uploaded with UploadFile and committed using DoneUploads for the sharing group -- queries the meta data on the sync server.
// This also returns a list of all sharing groups that the user is a member of.

public class FileIndexRequest : NSObject, RequestMessage {
#if DEBUG
    // Give a time value in seconds -- the server for sleep to test failure of API calls.
    public static let testServerSleepKey = "testServerSleep"
    public var testServerSleep:Int32?
#endif

    public var sharingGroupId: SharingGroupId!
 
    public required init?(json: JSON) {
        super.init()
#if DEBUG
        self.testServerSleep = Decoder.decode(int32ForKey: FileIndexRequest.testServerSleepKey)(json)
#endif
        self.sharingGroupId = Decoder.decode(int64ForKey: ServerEndpoint.sharingGroupIdKey)(json)

#if SERVER
        Log.info(message: "FileIndexRequest.testServerSleep: \(String(describing: testServerSleep))")
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
        result += [FileIndexRequest.testServerSleepKey ~~> self.testServerSleep]
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
        return self.nonNilKeys() + [FileIndexRequest.testServerSleepKey]
#else
        return self.nonNilKeys()
#endif
    }
    
    public func nonNilKeys() -> [String] { return [
        ServerEndpoint.sharingGroupIdKey]
    }
}

public class FileIndexResponse : ResponseMessage {
    public var responseType: ResponseType {
        return .json
    }
    
    // The master version for the requested sharing group.
    public static let masterVersionKey = "masterVersion"
    public var masterVersion:MasterVersionInt!
    
    // The files in the requested sharing group.
    public static let fileIndexKey = "fileIndex"
    public var fileIndex:[FileInfo]?
    
    // The sharing groups in which this user is a member.
    public static let sharingGroupsKey = "sharingGroups"
    public var sharingGroups:[SharingGroup]!
    
    public required init?(json: JSON) {
        self.masterVersion = Decoder.decode(int64ForKey: FileIndexResponse.masterVersionKey)(json)
        self.fileIndex = FileIndexResponse.fileIndexKey <~~ json
        self.sharingGroups = FileIndexResponse.sharingGroupsKey <~~ json
    }
    
    public convenience init?() {
        self.init(json:[:])
    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            FileIndexResponse.masterVersionKey ~~> self.masterVersion,
            FileIndexResponse.fileIndexKey ~~> self.fileIndex,
            FileIndexResponse.sharingGroupsKey ~~> self.sharingGroups
        ])
    }
}

