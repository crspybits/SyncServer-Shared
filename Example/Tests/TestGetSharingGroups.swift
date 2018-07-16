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
        let sharingGroupId1:SharingGroupId = 43
        
        guard let response = GetSharingGroupsResponse(json: [GetSharingGroupsResponse.sharingGroupIdsKey: [sharingGroupId1]]) else {
            XCTFail()
            return
        }
        
        XCTAssert(response.sharingGroupIds == [sharingGroupId1])
        
        guard let dict = response.toJSON(),
            let array = dict[GetSharingGroupsResponse.sharingGroupIdsKey] as? [SharingGroupId] else {
            XCTFail()
            return
        }
        
        XCTAssert(array == [sharingGroupId1])
    }
}
