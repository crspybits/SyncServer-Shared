//
//  RequestResponseTests.swift
//  SyncServer-Shared_Tests
//
//  Created by Christopher G Prince on 3/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import Foundation
@testable import SyncServer_Shared

class RequestResponseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUploadFileRequest() {
        let fileUUID = UUID().uuidString
        let appMetaData = AppMetaData(version: 0, contents: "Stuff")
        let uploadRequest = UploadFileRequest()
        uploadRequest.fileUUID = fileUUID
        uploadRequest.mimeType = "text/plain"
        uploadRequest.fileVersion = 0
        uploadRequest.masterVersion = 0
        uploadRequest.appMetaData = appMetaData
        uploadRequest.checkSum = "abc"
        uploadRequest.sharingGroupUUID = UUID().uuidString

        guard uploadRequest.valid() else {
            XCTFail()
            return
        }
        
        guard let dict = uploadRequest.toDictionary else {
            XCTFail()
            return
        }

        guard let request = try? MessageDecoder.decode(UploadFileRequest.self, from: dict) else {
            XCTFail()
            return
        }
        
        XCTAssert(request.valid() == true)
        XCTAssert(request.appMetaData != nil)
    }
    
    func testURLParametersForUploadDeletion() {
        let uuidString = Foundation.UUID().uuidString

        let sharingGroupUUID = UUID().uuidString
        
        let uploadDeletionRequest = UploadDeletionRequest()
        uploadDeletionRequest.fileUUID = uuidString
        uploadDeletionRequest.fileVersion = FileVersionInt(99)
        uploadDeletionRequest.masterVersion = MasterVersionInt(23)
        uploadDeletionRequest.actualDeletion = true
        uploadDeletionRequest.sharingGroupUUID = sharingGroupUUID
        
        let result = uploadDeletionRequest.urlParameters()

        let expectedURLParams =
            "actualDeletion=1&" +
            "fileUUID=\(uuidString)&" +
            "fileVersion=99&" +
            "masterVersion=23&" +
            "sharingGroupUUID=\(sharingGroupUUID)"
        
        XCTAssert(result == expectedURLParams, "Expected: \(String(describing: expectedURLParams)); actual: \(String(describing: result))")
    }
}
