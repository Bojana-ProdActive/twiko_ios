//
//  AlarmManagerTests.swift
//  TwikoTests
//
//  Created by Goran Tokovic on 2.7.21..
//

import NDBluetoothLibrary
@testable import Twiko
import XCTest

class AlarmManagerTests: XCTestCase {

    var newAlarmAvailableCalled: Bool = false
    var sut: AlarmManager!

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = AlarmManager(delegate: self)
    }

    /**
     Test `AlarmManager.maskAllExcept( _ alarmTypes: [AlarmType])`:
     - For passed `[.cartridgeDisconnected, .blockageDetected]` values the `excludedAlarms` should contain all alarmTypes except `[.cartridgeDisconnected, .blockageDetected]`.
     */
    func testMaskAllExcept() {
        let input: Set<AlarmType> = [.cartridgeDisconnected, .blockageDetected]
        let expect: Set<AlarmType> = {
            var result: Set<AlarmType> = Set(AlarmType.allCases)
            // Remove from imput
            for item in input {
                result.remove(item)
            }

            // Remove unmascable
            for item in sut.unmaskableAlarmTypes {
                result.remove(item)
            }
            return result
        }()

        sut.maskAllExcept(input)

        XCTAssertEqual(sut.maskedAlarmTypes, expect)
    }

    func testUnmascableAlarmTypes() {
        let unmascableAlarms: Set<AlarmType> = [
            .noAlarm,
            .pumpMalfunction
        ]

        XCTAssertEqual(sut.unmaskableAlarmTypes, unmascableAlarms)
    }

    /**
     Test `AlarmManager.mask( _ alarmTypes: [AlarmType])`:
     - For array `[.cartridgeDisconnected, .blockageDetected]`  the `excludedAlarms` should contain only `[.cartridgeDisconnected, .blockageDetected]`
     */
    func testMaskAlarmTypes() {
        let expected: Set<AlarmType> = [.cartridgeDisconnected, .blockageDetected]
        let input: Set<AlarmType> = expected.union(sut.unmaskableAlarmTypes)
        sut.mask(input)
        XCTAssertEqual(sut.maskedAlarmTypes, expected)
    }

    /**
     Test `AlarmManager.pumpAlarmRaised(_ pumpAlarm: PumpAlarm)`:
     - Masked alarms: All except `AlarmType.pumpMalfunction`
     -  For `EmptyBattery` alarm AlertManager should not call `AlarmManagerDelegate.newAlarmAvailable(_ alarm: PumpAlarm)`
     - For `PumpMalfunction` alarm AlertManager should not call `AlarmManagerDelegate.newAlarmAvailable(_ alarm: PumpAlarm)`
     */
    func testPumpAlarmRaised() {
        let excludedAlarmTypes: Set<AlarmType> = [.pumpMalfunction]
        let pumpMalfunctionAlarm = PumpAlarm(code: AlarmType.pumpMalfunction.rawValue, detailsCode: 12, isSoundEnabled: true, noTreatmentDuration: 2, alarmDescription: "test")
        let emptyBatteryAlarm = PumpAlarm(code: AlarmType.emptyBattery.rawValue, detailsCode: 12, isSoundEnabled: true, noTreatmentDuration: 2, alarmDescription: "test")

        XCTAssertFalse(newAlarmAvailableCalled)
        sut.maskAllExcept(excludedAlarmTypes)
        sut.pumpAlarmRaised(emptyBatteryAlarm)
        XCTAssertFalse(newAlarmAvailableCalled)
        sut.pumpAlarmRaised(pumpMalfunctionAlarm)
        XCTAssertTrue(newAlarmAvailableCalled)
    }
}

extension AlarmManagerTests: AlarmManagerDelegate {
    func newAlarmAvailable(_ alarm: PumpAlarm, fromBroadcast: Bool) {
        newAlarmAvailableCalled = true
    }

    func alarmDataChanged(_ alarm: PumpAlarm, fromBroadcast: Bool) {

    }

    func allAlarmsSolved() {

    }
}
