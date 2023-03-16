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

    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vm = ContentViewModel()
        
        let mockReportIds: String = "0,1,2,3,4,5,6,7,8,9"
        var mockDataMessage = "FirstRow"
        for i in mockReportIds.components(separatedBy: ",") {
            mockDataMessage.append("\n\(i)")
        }
        
        vm?.healthReport.doc = CSVDocument(message: mockDataMessage)
        vm?.healthReport.transferred = true
    }

    @MainActor override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        vm = nil
    }

    @MainActor func test_parseReport() async throws {
       //Given
        let randId1 = String(Int.random(in: 1..<9))
        let randId2 = String(Int.random(in: 1..<9))
        let randId3 = String(Int.random(in: 1..<9))
        let mockWeeklyIds: String = "\(randId1),\(randId2),\(randId3)"
        vm?.custIDs = mockWeeklyIds

        //When
        await vm?.generateReport()
        let rows = ["FirstRow",randId1,randId2,randId3]
        let testRows = vm?.healthReport.doc.message.components(separatedBy: "\n")
        
        //Let
        for i in 0..<rows.count {
            XCTAssertTrue(testRows?.contains(rows[i]) ?? false)
        }
        
    }
    
    @MainActor func test_parseReportNoExtraniousIds() async throws {
        //Given
        let mockWeeklyIds = "0,1,2,3,4"
        vm?.custIDs = mockWeeklyIds

        //When
        await vm?.generateReport()
        let testRows = vm?.exportReport.doc.message.components(separatedBy: "\n")

        //Let
        for i in 5...10 {
            XCTAssertFalse(testRows?.contains(String(i)) ?? true)
        }
    }
    
    @MainActor func test_onlyOneExportReportHeaderPerCustID() async throws {
        //Given
        let mockWeeklyIds = "0,1,2,3,4"
        vm?.custIDs = mockWeeklyIds
        
        let mockHealthReportResults = "FirstRow\n0\n1\n1\n2\n2\n3\n4\n"
        vm?.healthReport.doc = CSVDocument(message: mockHealthReportResults)
        vm?.healthReport.transferred = true
        vm?.healthReport.rowCount = 8
        
        let mockOtherReportResults = "FirstRow\n0\n1\n2\n3\n4\n"
        vm?.liveReport.doc = CSVDocument(message: mockOtherReportResults)
        vm?.liveReport.transferred = true
        vm?.liveReport.rowCount = 8
        
        vm?.ingestionReport.doc = CSVDocument(message: mockOtherReportResults)
        vm?.ingestionReport.transferred = true
        vm?.ingestionReport.rowCount = 8

        //When
        await vm?.generateReport()
        let testRows = vm?.exportReport.doc.message.components(separatedBy: "\n")

        //Let
        var cancelledOrdersCount = 0
        var liveIntegrationCount = 0
        var menuIngestionCount = 0
        
        for row in testRows! {
            let testColumns = row.components(separatedBy: ",")
            if(testColumns[0] == "Cancelled Orders") {cancelledOrdersCount += 1}
            if(testColumns[0] == "Integration Live") {liveIntegrationCount += 1}
            if(testColumns[0] == "Latest Ingestion") {menuIngestionCount += 1}
        }
        
        XCTAssertTrue(vm?.exportReport.doc.message != "")
        XCTAssertTrue(cancelledOrdersCount <= 5 && liveIntegrationCount <= 5 && menuIngestionCount <= 5)
    }
    
    //Gives Empty message if No Cust IDs are found
    
    //Validate Succeeds and Fails According

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
