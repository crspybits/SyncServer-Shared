//
//  GlossAppMetaDataTests.swift
//  SyncServer-Shared_Tests
//
//  Created by Christopher G Prince on 3/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import Foundation
@testable import SyncServer_Shared

class GlossAppMetaDataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let fileUUID = UUID().uuidString
        let uploadRequest = UploadFileRequest(json: [
            UploadFileRequest.fileUUIDKey : fileUUID,
            UploadFileRequest.mimeTypeKey: "text/plain",
            UploadFileRequest.fileVersionKey: 0,
            UploadFileRequest.masterVersionKey: 0,
            UploadFileRequest.appMetaDataKey: [
                AppMetaData.versionKey : 0,
                AppMetaData.contentsKey: "Stuff"
            ]
        ])
        
        guard uploadRequest != nil else {
            XCTFail()
            return
        }
        
        XCTAssert(uploadRequest!.appMetaData != nil)
        
        let json = uploadRequest!.toJSON()
        print("json: \(String(describing: json))")
        
        guard let dict = json?[UploadFileRequest.appMetaDataKey] as? [String: Any] else {
            XCTFail()
            return
        }
        
        guard dict[AppMetaData.versionKey] != nil && dict[AppMetaData.contentsKey] != nil else {
            XCTFail()
            return
        }
    }
}
