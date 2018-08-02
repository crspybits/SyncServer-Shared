//
//  TestGetSharingGroups.swift
//  SyncServer-Shared_Tests
//
//  Created by Christopher G Prince on 7/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import SyncServer_Shared

class TestGetSharingGroups: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let sharingGroup = SharingGroup()!
        sharingGroup.sharingGroupId = 43
        sharingGroup.sharingGroupName = "Foobar"
        guard let sharingGroupJson = sharingGroup.toJSON() else {
            XCTFail()
            return
        }
        
        guard let response = GetSharingGroupsResponse(json: [GetSharingGroupsResponse.sharingGroupsKey: [sharingGroupJson]]) else {
            XCTFail()
            return
        }
        
        XCTAssert(response.sharingGroups.count == 1)
        XCTAssert(response.sharingGroups[0].sharingGroupId == sharingGroup.sharingGroupId)
        XCTAssert(response.sharingGroups[0].sharingGroupName == sharingGroup.sharingGroupName)
        
        guard let dict = response.toJSON(),
            let _ = dict[GetSharingGroupsResponse.sharingGroupsKey] as? [Any] else {
            XCTFail()
            return
        }

        guard let _ = JSONExtras.toJSONString(dict: dict) else {
            XCTFail()
            return
        }
    }
}
