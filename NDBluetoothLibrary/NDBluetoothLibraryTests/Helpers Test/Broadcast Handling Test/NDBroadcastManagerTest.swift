//
//  NDBroadcastManagerTest.swift
//  NDBluetoothLibraryTests
//
//  Created by Digital Atrium on 11.6.21..
//
@testable import NDBluetoothLibrary
import XCTest

class NDBroadcastManagerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

//final class NDPumpManagerTestData: NDPumpManagerProtocol {

//    private let queue = DispatchQueue(label: "NDSharedPumpQueue", attributes: .concurrent)
//
//    
//    private var pumpDictionary: [String: NDPump] = []
//
//    private var isPumpConnected = false {
//        didSet {
////            NotificationCenter.default.post(Notification(name: NDNotificationName.changedBLEConnectionStatusNotificationName))
//        }
//    }
//    func startListeningForData() {
//        <#code#>
//    }
//
//    func stopListeningForData() {
//        <#code#>
//    }
//
//    func getPumpDataForKey(key: String) -> NDPump? {
//        <#code#>
//    }
//
//    func getBluetootStatus() -> CBManagerState? {
//        <#code#>
//    }
//
//    func getIsPumpConnected() -> Bool {
//        <#code#>
//    }
//
//    func clearPumpDictionary() {
//        <#code#>
//    }
//
//    func setIsPumpConnected(_ isConnected: Bool) {
//        <#code#>
//    }
//
//    func setPumpDataForKey(pumpData: NDPump, key: String) {
//        <#code#>
//    }
