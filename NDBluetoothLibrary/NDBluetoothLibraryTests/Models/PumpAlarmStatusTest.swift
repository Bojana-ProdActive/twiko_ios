//
//  PumpAlarmStatusTest.swift
//  NDBluetoothLibraryTests
//
//  Created by Bojana Vojvodic on 21.6.21..
//
@testable import NDBluetoothLibrary
import XCTest

class PumpAlarmStatusTest: XCTestCase {

    // MARK: - Expected values

    private var expectedAlarmCode: UInt8 = 0
    private var expectedAlarmDetailsCode: UInt8 = 0
    private var expectedIsSoundEnabled: Bool = false
    private var expectedNoTreatmentDuration: UInt32 = 0

    /**
         This method test set pump alarm status data.

         After setting input data: `alarmCode: 0, alarmDetailsCode: 0, isSoundEnabled: false, noTreatmentDuration: 0` pump status should create output:
         - Alarm code: `0`
         - Alarm details code: `0`
         - Is sound enabled: `false`
         - No treatment duration: `0`
         */
    func testSetPumpAlarmStatusDataAllZero() {
        /// Pump alarm status expected value
        expectedAlarmCode = 0
        expectedAlarmDetailsCode = 0
        expectedIsSoundEnabled = false
        expectedNoTreatmentDuration = 0

        /// Pump alarm status expected values
        var pumpAlarmStatus = PumpAlarm()
        pumpAlarmStatus.alarmCode = 0
        pumpAlarmStatus.alarmDetailsCode = 0
        pumpAlarmStatus.isSoundEnabled = false
        pumpAlarmStatus.noTreatmentDuration = 0

        // Test Pump alarm status data
        XCTAssertEqual(pumpAlarmStatus.alarmCode, expectedAlarmCode)
        XCTAssertEqual(pumpAlarmStatus.alarmDetailsCode, expectedAlarmDetailsCode)
        XCTAssertEqual(pumpAlarmStatus.isSoundEnabled, expectedIsSoundEnabled)
        XCTAssertEqual(pumpAlarmStatus.noTreatmentDuration, expectedNoTreatmentDuration)
    }

    /**
         This method test set pump alarm status data.

         After setting input data: `alarmCode: 1, alarmDetailsCode: 9, isSoundEnabled: true, noTreatmentDuration: 2584` pump status should create output:
         - Alarm code: `1`
         - Alarm details code: `9`
         - Is sound enabled: `true`
         - No treatment duration: `2584`
         */
    func testSetPumpAlarmStatusData() {
        /// Pump alarm status expected value
        expectedAlarmCode = 1
        expectedAlarmDetailsCode = 9
        expectedIsSoundEnabled = true
        expectedNoTreatmentDuration = 2584

        /// Pump alarm status expected values
        var pumpAlarmStatus = PumpAlarm()
        pumpAlarmStatus.alarmCode = 1
        pumpAlarmStatus.alarmDetailsCode = 9
        pumpAlarmStatus.isSoundEnabled = true
        pumpAlarmStatus.noTreatmentDuration = 2584

        // Test Pump alarm status data
        XCTAssertEqual(pumpAlarmStatus.alarmCode, expectedAlarmCode)
        XCTAssertEqual(pumpAlarmStatus.alarmDetailsCode, expectedAlarmDetailsCode)
        XCTAssertEqual(pumpAlarmStatus.isSoundEnabled, expectedIsSoundEnabled)
        XCTAssertEqual(pumpAlarmStatus.noTreatmentDuration, expectedNoTreatmentDuration)
    }

}
