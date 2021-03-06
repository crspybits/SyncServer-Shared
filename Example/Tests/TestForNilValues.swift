//
//  TestForNilValues.swift
//  SyncServer-Shared_Tests
//
//  Created by Christopher G Prince on 6/17/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import SyncServer_Shared

class TestForNilValues: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRedeemSharingInvitationRequest() {
        let upload = RedeemSharingInvitationRequest()
        XCTAssert(!upload.valid())
    }
    
    func testUploadDeletion() {
        let uploadDeletion = UploadDeletionRequest()
        uploadDeletion.fileUUID = UUID().uuidString
        uploadDeletion.fileVersion = 1
        uploadDeletion.masterVersion = 1
        uploadDeletion.sharingGroupUUID = UUID().uuidString
        uploadDeletion.actualDeletion = true        
        guard let dict = uploadDeletion.toDictionary else {
            XCTFail()
            return
        }

        guard let output = try? UploadDeletionRequest.decode(dict) as? UploadDeletionRequest else {
            XCTFail()
            return
        }
        
        XCTAssert(output.actualDeletion == true)
    }
    
    func testDownloadFileResponse() {
        let response = DownloadFileResponse()
        response.contentsChanged = false
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(response) else {
            XCTFail()
            return
        }
        let json = String(data: jsonData, encoding: .utf8)
        print("\(String(describing: json))")
    }
    
    func testEncodeToJsonString() {
        let response = DownloadFileResponse()
        response.contentsChanged = false
        guard let result = MessageEncoder.toJSONString(encodable: response) else {
            XCTFail()
            return
        }
        
        print("\(result)")
    }
}
