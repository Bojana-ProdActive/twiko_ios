//
//  NDPumpStatusTest.swift
//  NDBluetoothLibraryTests
//
//  Created by Digital Atrium on 16.6.21..
//
@testable import NDBluetoothLibrary
import XCTest

class NDPumpStatusTest: XCTestCase {

    private var expectedCartridgeAttached = true
    private var expectedCoupledToStation = true
    private var expectedDeliveringMedicine = true
    private var expectedFtuFinished = true
    private var expectedInFillingState = true
    private var expectedInFullTreatmentFlow = true
    private var expectedIsCartridgeRemovedInLastHour = true
    private var expectedIsAlarmAcknowledged = true
    private var testValue = Data([0xFF])
    private var pumpStatus: NDPumpStatus = NDPumpStatus()

    /**
         This method test set pump status register.

         After setting input data: `{0xFF}` pump status should create output:
         - Is FTU done: `true`
         - Cartridge attached: `true`
         - Coupled to the Station: `true`
         - Delivering medicine: `true`
         - Is in fill state: `true`
         - Is in full treatment flow: `true`
         - Is Cartridge Removed In Last Hour: `true`
         - Is Alarm Acknowledged: `true`
         */
    func testSetStatusAllTrue() {
        /// Status expected value
        expectedFtuFinished = true
        expectedCartridgeAttached = true
        expectedCoupledToStation = true
        expectedDeliveringMedicine = true
        expectedInFillingState = true
        expectedInFullTreatmentFlow = true
        expectedIsCartridgeRemovedInLastHour = true
        expectedIsAlarmAcknowledged = true

        let bytes = [UInt8](testValue)
        pumpStatus = NDBroadcastDataParser.parsePumpStatusRegister(statusByte: bytes[0])

        // Test Pump status data
        XCTAssertEqual(pumpStatus.isFtuDone, expectedFtuFinished)
        XCTAssertEqual(pumpStatus.isAlarmAcknowledged, expectedIsAlarmAcknowledged)
        XCTAssertEqual(pumpStatus.cartridgeAttached, expectedCartridgeAttached)
        XCTAssertEqual(pumpStatus.isCartridgeRemovedInLastOneHour, expectedIsCartridgeRemovedInLastHour)
        XCTAssertEqual(pumpStatus.coupledToStation, expectedCoupledToStation)
        XCTAssertEqual(pumpStatus.inFillingState, expectedInFillingState)
        XCTAssertEqual(pumpStatus.deliveringMedicine, expectedDeliveringMedicine)
        XCTAssertEqual(pumpStatus.inFullTreatmentFlow, expectedInFullTreatmentFlow)
    }

    /**
         This method test set pump status register.

         After setting input data: `{0x00}` pump status should create output:
         - Is FTU done: `false`
         - Cartridge attached: `false`
         - Coupled to the Station: `false`
         - Delivering medicine: `false`
         - Is in fill state: `false`
         - Is in full treatment flow: `false`
         - Is Cartridge Removed In Last Hour: `false`
         - Is Alarm Acknowledged: `false`
         */
    func testSetStatusAllFalse() {
        /// Status expected value
        expectedFtuFinished = false
        expectedCartridgeAttached = false
        expectedCoupledToStation = false
        expectedInFillingState = false
        expectedInFullTreatmentFlow = false
        expectedDeliveringMedicine = false
        expectedIsCartridgeRemovedInLastHour = false
        expectedIsAlarmAcknowledged = false

        testValue = Data([0x00])
        let bytes = [UInt8](testValue)
        pumpStatus = NDBroadcastDataParser.parsePumpStatusRegister(statusByte: bytes[0])

        // Test Pump status data
        XCTAssertEqual(pumpStatus.isFtuDone, expectedFtuFinished)
        XCTAssertEqual(pumpStatus.isAlarmAcknowledged, expectedIsAlarmAcknowledged)
        XCTAssertEqual(pumpStatus.cartridgeAttached, expectedCartridgeAttached)
        XCTAssertEqual(pumpStatus.isCartridgeRemovedInLastOneHour, expectedIsCartridgeRemovedInLastHour)
        XCTAssertEqual(pumpStatus.coupledToStation, expectedCoupledToStation)
        XCTAssertEqual(pumpStatus.inFillingState, expectedInFillingState)
        XCTAssertEqual(pumpStatus.deliveringMedicine, expectedDeliveringMedicine)
        XCTAssertEqual(pumpStatus.inFullTreatmentFlow, expectedInFullTreatmentFlow)
    }

    /**
         This method test equal function for same data.

         Equals function shoud be true after setting input data value for two pumps:
         - Is FTU done: `true`
         - Cartridge attached: `true`
         - Coupled to the Station: `true`
         - Delivering medicine: `true`
         - Is in fill state: `true`
         - Is in full treatment flow: `true`
         - Is Cartridge Removed In Last Hour: `true`
         - Is Alarm Acknowledged: `true`
         */
    func testEqualFunction() {
        /// Set first pump status
        var pumpStatusOne = NDPumpStatus()

        pumpStatusOne.isFtuDone = false
        pumpStatusOne.cartridgeAttached = true
        pumpStatusOne.inFillingState = true
        pumpStatusOne.inFullTreatmentFlow = true
        pumpStatusOne.isAlarmAcknowledged = true
        pumpStatusOne.isCartridgeRemovedInLastOneHour = true
        pumpStatusOne.coupledToStation = true
        pumpStatusOne.deliveringMedicine = true

        var pumpStatusTwo = NDPumpStatus()

        pumpStatusTwo.isFtuDone = false
        pumpStatusTwo.cartridgeAttached = true
        pumpStatusTwo.inFillingState = true
        pumpStatusTwo.inFullTreatmentFlow = true
        pumpStatusTwo.isAlarmAcknowledged = true
        pumpStatusTwo.isCartridgeRemovedInLastOneHour = true
        pumpStatusTwo.coupledToStation = true
        pumpStatusTwo.deliveringMedicine = true

        XCTAssertTrue(pumpStatusOne == pumpStatusTwo)
    }

    /**
         This method test equal function for different data.

         Equals function shoud be false after setting input data value for two pumps:

            Pump One:
            - Is FTU done: `false`
     
            Pump Two:
            - Is FTU done: `true`
         */
    func testNonEqualFunction() {
        let pumpStatusOne = NDPumpStatus()
        pumpStatus.isFtuDone = false

        var pumpStatusTwo = NDPumpStatus()
        pumpStatusTwo.isFtuDone = true

        XCTAssertFalse(pumpStatusOne == pumpStatusTwo)
    }
}
