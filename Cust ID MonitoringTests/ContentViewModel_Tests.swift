//
//  ContentViewModel_Tests.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 3/5/23.
//

import XCTest
@testable import Cust_ID_Monitoring

final class ContentViewModel_Tests: XCTestCase {
    
    var vm: ContentViewModel?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vm = ContentViewModel()
        
        let mockReportIds: String = "0,1,2,3,4,5,6,7,8,9"
        var mockDataMessage = "FirstRow"
        for i in mockReportIds.components(separatedBy: ",") {
            mockDataMessage.append("\n\(i)")
        }
        
        vm?.document = CSVDocument(message: mockDataMessage)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        vm = nil
    }

    func test_parsesIdsFromCSV() async throws {
       //Given
        let randId1 = String(Int.random(in: 1..<9))
        let randId2 = String(Int.random(in: 1..<9))
        let randId3 = String(Int.random(in: 1..<9))
        let mockWeeklyIds: String = "\(randId1),\(randId2),\(randId3)"
        vm?.custIDs = mockWeeklyIds

        //When
        await vm?.parseDoc()
        let rows = ["FirstRow",randId1,randId2,randId3]
        let testRows = vm?.document.message.components(separatedBy: "\n")
        
        //Let
        for i in 0..<rows.count {
            XCTAssertTrue(testRows?.contains(rows[i]) ?? false)
        }
        
    }
    
    func test_doNotParseOtherIdsFromCSV() async throws {
        //Given
        let mockWeeklyIds = "0,1,2,3,4"
        vm?.custIDs = mockWeeklyIds

        //When
        await vm?.parseDoc()
        let testRows = vm?.document.message.components(separatedBy: "\n")

        //Let
        for i in 5...10 {
            XCTAssertFalse(testRows?.contains(String(i)) ?? true)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
