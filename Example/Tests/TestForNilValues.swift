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
       let upload = RedeemSharingInvitationRequest(json: [:])
        XCTAssert(upload == nil)
    }
}
