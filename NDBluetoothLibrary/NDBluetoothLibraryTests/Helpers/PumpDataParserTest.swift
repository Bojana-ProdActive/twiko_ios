//
//  PumpAlarmStatusDataParserTest.swift
//  NDBluetoothLibraryTests
//
//  Created by Digital Atrium on 21.6.21..
//
@testable import NDBluetoothLibrary
import XCTest

class PumpDataParserTest: XCTestCase {

    // MARK: - Pump alarm status data

    private var pumpAlarmStatusData = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])

    // MARK: - Expected values

    private var expectedAlarmCode: UInt8 = 0
    private var expectedAlarmDetailsCode: UInt8 = 0
    private var expectedIsSoundEnabled: Bool = false
    private var expectedNoTreatmentDuration: UInt32 = 0

    private var expectedTime = UInt64(1639883723)
    private var pumpTimeData = Data([0x00, 0x00, 0x00, 0x00, 0x61, 0xBE, 0xA3, 0xCB])

    /**
         This method test parsing pump alarm status data from byte arry.

         After setting input data: `[0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]` pump status should create output:
         - Alarm code: `0`
         - Alarm details code: `0`
         - Is sound enabled: `false`
         - No treatment duration: `0`
         */
    func testSetPumpStatusAllZero() {
        /// Pump alarm status expected value
        expectedAlarmCode = 0
        expectedAlarmDetailsCode = 0
        expectedIsSoundEnabled = false
        expectedNoTreatmentDuration = 0

        /// Pump alarm status expected values
        let parsedPumpAlarmStatusData = PumpDataParser.parseAlarmData(advertisementData: pumpAlarmStatusData)

        // Test Pump data
        XCTAssertEqual(parsedPumpAlarmStatusData?.alarmCode, expectedAlarmCode)
        XCTAssertEqual(parsedPumpAlarmStatusData?.alarmDetailsCode, expectedAlarmDetailsCode)
        XCTAssertEqual(parsedPumpAlarmStatusData?.isSoundEnabled, expectedIsSoundEnabled)
        XCTAssertEqual(parsedPumpAlarmStatusData?.noTreatmentDuration, expectedNoTreatmentDuration)
    }

    /**
         This method test parsing pump alarm status data from byte arry.

         After setting input data: `[0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03]` pump status should create output:
         - Alarm code: `3`
         - Alarm details code: `0`
         - Is sound enabled: `false`
         - No treatment duration: `0`
         */
    func testSetPumpStatusAlarmCodeThree() {
        /// Pump alarm status expected value
        expectedAlarmCode = 3
        expectedAlarmDetailsCode = 0
        expectedIsSoundEnabled = false
        expectedNoTreatmentDuration = 0

        /// Pump alarm status expected values
        pumpAlarmStatusData = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03])
        let parsedPumpAlarmStatusData = PumpDataParser.parseAlarmData(advertisementData: pumpAlarmStatusData)

        // Test Pump data
        XCTAssertEqual(parsedPumpAlarmStatusData?.alarmCode, expectedAlarmCode)
        XCTAssertEqual(parsedPumpAlarmStatusData?.alarmDetailsCode, expectedAlarmDetailsCode)
        XCTAssertEqual(parsedPumpAlarmStatusData?.isSoundEnabled, expectedIsSoundEnabled)
        XCTAssertEqual(parsedPumpAlarmStatusData?.noTreatmentDuration, expectedNoTreatmentDuration)
    }

    /**
         This method test parsing pump clock synchronization data parsing.

         After setting input data: `[0x00, 0x00, 0x00, 0x00, 0x61, 0xBE, 0xA3, 0xCB]` pump status should create output:
         - UInt64 time value: `1639883723`
         */
    func testParsingTimeData_Equal() {
        let parsedTimeData = PumpDataParser.parsePumpClockSynchronizationData(advertisementData: pumpTimeData)

        XCTAssertEqual(expectedTime, parsedTimeData)
    }

    /**
         This method test parsing pump clock synchronization data parsing.

         After setting input data: `[0x00, 0x00, 0x00, 0x00, 0x61, 0xBE, 0xA3, 0xCB]` pump status should not create output:
         - UInt64 time value: `28`
         */
    func testParsingTimeData_NotEqual() {
        expectedTime = UInt64(28)
        let parsedTimeData = PumpDataParser.parsePumpClockSynchronizationData(advertisementData: pumpTimeData)

        XCTAssertNotEqual(expectedTime, parsedTimeData)
    }

}
