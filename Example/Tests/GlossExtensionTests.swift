//
//  GlossExtensionTests.swift
//  Server
//
//  Created by Christopher Prince on 12/28/17.
//
//

import XCTest
import Foundation
@testable import SyncServer_Shared

class GlossExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatInt32CorrectValueWorks() {
        let value:Int32 = 43
        let json = ["test": "\(value)"]
        let result = TestSupport.decode(int32ForKey: "test")(json)
        XCTAssert(result == value)
    }
    
    func testThatInt32IncorrectValueFails() {
        let value:Int32 = 43
        let json = ["test": "\(value)"]
        let result = TestSupport.decode(int32ForKey: "test")(json)
        XCTAssert(result != 42)
    }
    
    func testThatInt64CorrectValueWorks() {
        let value:Int64 = 876
        let json = ["test": "\(value)"]
        let result = TestSupport.decode(int64ForKey: "test")(json)
        XCTAssert(result == value)
    }
    
    func testThatFloatCorrectValueWorks() {
        let value:Float = 198.23
        let json = ["test": "\(value)"]
        let result = TestSupport.decode(floatForKey: "test")(json)
        XCTAssert(result == value)
    }
}


