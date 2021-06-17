//
//  PumpCommandTypeTests.swift
//  NDBluetoothLibraryTests
//
//  Created by Goran Tokovic on 17.6.21..
//

@testable import NDBluetoothLibrary
import XCTest

final class PumpCommandTypeTests: XCTestCase {

    /**
     Test  `PumpCommandType.finishFtu` command type:
     - vaule is equal to `0x01`
     - has one byte size (UInt8 type)
     */
    func testFinishFtuRawValue() {
        XCTAssertEqual( PumpCommandType.finishFtu.rawValue, UInt8(0x01))
    }

    /**
     Test  `PumpCommandType.turnOffThePump` command type:
     - vaule is equal to `0x02`
     - has one byte size (UInt8 type)
     */
    func testTurnOfThePumpRawValue() {
        XCTAssertEqual( PumpCommandType.turnOffThePump.rawValue, UInt8(0x02))
    }

    /**
     Test  `PumpCommandType.disconnect` command type:
     - vaule is equal to `0x03`
     - has one byte size (UInt8 type)
     */
    func testDisconnectRawValue() {
        XCTAssertEqual( PumpCommandType.disconnect.rawValue, UInt8(0x03))
    }

    /**
     Test  `PumpCommandType.startRegimenDownload` command type:
     - vaule is equal to `0x04`
     - has one byte size (UInt8 type)
     */
    func testStartRegimenDownloadRawValue() {
        XCTAssertEqual( PumpCommandType.startRegimenDownload.rawValue, UInt8(0x04))
    }

    /**
     Test  `PumpCommandType.startRegimenUpload` command type:
     - vaule is equal to `0x05`
     - has one byte size (UInt8 type)
     */
    func testStartRegimenUploadRawValue() {
        XCTAssertEqual( PumpCommandType.startRegimenUpload.rawValue, UInt8(0x05))
    }

    /**
     Test  `PumpCommandType.finishRegimenUpload` command type:
     - vaule is equal to `0x06`
     - has one byte size (UInt8 type)
     */
    func testFinishRegimenUploadRawValue() {
        XCTAssertEqual( PumpCommandType.finishRegimenUpload.rawValue, UInt8(0x06))
    }

    /**
     Test  `PumpCommandType.unpair` command type:
     - vaule is equal to `0x09`
     - has one byte size (UInt8 type)
     */
    func testUnpairRawValue() {
        XCTAssertEqual( PumpCommandType.unpair.rawValue, UInt8(0x09))
    }

    /**
     Test  `PumpCommandType.startFillingMedication` command type:
     - vaule is equal to `0x0a`
     - has one byte size (UInt8 type)
     */
    func testStartFillingMedicationRawValue() {
        XCTAssertEqual( PumpCommandType.startFillingMedication.rawValue, UInt8(0x0a))
    }

    /**
     Test  `PumpCommandType.startPriming` command type:
     - vaule is equal to `0x0b`
     - has one byte size (UInt8 type)
     */
    func testStartPrimingRawValue() {
        XCTAssertEqual( PumpCommandType.startPriming.rawValue, UInt8(0x0b))
    }

    /**
     Test  `PumpCommandType.startWatchdogTest` command type:
     - vaule is equal to `0x0c`
     - has one byte size (UInt8 type)
     */
    func testStartWatchdogTestRawValue() {
        XCTAssertEqual( PumpCommandType.startWatchdogTest.rawValue, UInt8(0x0c))
    }

    /**
     Test  `PumpCommandType.clearPumpLog` command type:
     - vaule is equal to `0x0d`
     - has one byte size (UInt8 type)
     */
    func testClearPumpLogRawValue() {
        XCTAssertEqual( PumpCommandType.clearPumpLog.rawValue, UInt8(0x0d))
    }

    /**
     Test  `PumpCommandType.switchToFillState` command type:
     - vaule is equal to `0x0e`
     - has one byte size (UInt8 type)
     */
    func testSwitchToFillStateRawValue() {
        XCTAssertEqual( PumpCommandType.switchToFillState.rawValue, UInt8(0x0e))
    }

    /**
     Test  `PumpCommandType.stopLogsDownload` command type:
     - vaule is equal to `0x0f`
     - has one byte size (UInt8 type)
     */
    func testStopLogsDownloadRawValue() {
        XCTAssertEqual( PumpCommandType.stopLogsDownload.rawValue, UInt8(0x0f))
    }

    /**
     Test  `PumpCommandType.sendThePumpToTheBootloader` command type:
     - vaule is equal to `0x10`
     - has one byte size (UInt8 type)
     */
    func testSendThePumpToTheBoothloaderRawValue() {
        XCTAssertEqual( PumpCommandType.sendThePumpToTheBootloader.rawValue, UInt8(0x10))
    }

    /**
     Test  `PumpCommandType.acknowledgeAlarm` command type:
     - vaule is equal to `0x11`
     - has one byte size (UInt8 type)
     */
    func testAcknowledgeAlarmRawValue() {
        XCTAssertEqual( PumpCommandType.acknowledgeAlarm.rawValue, UInt8(0x11))
    }

    /**
     Test  `PumpCommandType.keepAlive` command type:
     - vaule is equal to `0x12`
     - has one byte size (UInt8 type)
     */
    func testKeepAliveRawValue() {
        XCTAssertEqual( PumpCommandType.keepAlive.rawValue, UInt8(0x12))
    }

    /**
     Test  `PumpCommandType.resetFtuAndSendToShipMode` command type:
     - vaule is equal to `0x13`
     - has one byte size (UInt8 type)
     */
    func testResetToFtuAndSendToTheShipModeRawValue() {
        XCTAssertEqual( PumpCommandType.resetFtuAndSendToShipMode.rawValue, UInt8(0x13))
    }

    /**
     Test  `PumpCommandType.errorCallbacks` command type:
     - vaule is equal to `0xff`
     - has one byte size (UInt8 type)
     */
    func testErrorCallbacksRawValue() {
        XCTAssertEqual( PumpCommandType.errorCallbacks.rawValue, UInt8(0xff))
    }
}
