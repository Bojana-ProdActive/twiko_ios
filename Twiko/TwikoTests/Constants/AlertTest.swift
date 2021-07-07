//
//  AlertTest.swift
//  NDBluetoothLibraryTests
//
//  Created by Bojana Vojvodic on 30.6.21..
//
@testable import Twiko
import XCTest

class AlertTest: XCTestCase {

    private var expectedAlertPriority = AlarmPriority.noAlert

    /**
         This method testing if priority of noAlarm alert is noAlert.

         NoAlert  should be:
         - `noAlarm`
         */
    func testNoAlarmPriority() {
        expectedAlertPriority = .noAlert

        XCTAssertEqual(AlarmType.noAlarm.getAlertPriority(), expectedAlertPriority)
    }

    /**
         This method testing if all high priority alarms returns `high` for priority type..

         High priority alarms should be:
         - `pumpMalfunction`
         - `emptyBattery`
         - `emptyDrug`
         - `drugExpired`
         - `blockageDetected`
         - `cartridgeDisconnected`
         - `treatmentPausedTooLong`
         */
    func testHighAlertPriority() {
        expectedAlertPriority = .high

        XCTAssertEqual(AlarmType.pumpMalfunction.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(AlarmType.emptyBattery.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(AlarmType.emptyDrug.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(AlarmType.drugExpired.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(AlarmType.blockageDetected.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(AlarmType.cartridgeDisconnected.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(AlarmType.treatmentPausedTooLong.getAlertPriority(), expectedAlertPriority)
    }

    /**
         This method testing if all medium priority alarms returns `medium` for priority type..

         Medium priority alarms should be:
         - `treatmentPaused`
         */
    func testMediumAlertPriority() {
        expectedAlertPriority = .medium

        XCTAssertEqual(AlarmType.treatmentPaused.getAlertPriority(), expectedAlertPriority)
    }

    /**
         This method testing if all low priority alarms returns `low` for priority type..

         Low priority alarms should be:
         - `pumpBatteryLow`
         - `drugDeliveryWillStopScan`
         */
    func testLowAlertPriority() {
        expectedAlertPriority = .low

        XCTAssertEqual(AlarmType.pumpBatteryLow.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(AlarmType.drugDeliveryWillStopScan.getAlertPriority(), expectedAlertPriority)
    }

    /**
         This method testing if all notifications returns `notDefined` for priority type..

         Notification alerts should be:
         - `fsMalfuncionNotification`
         - `fsFillProcessInterruptedNotification`
         - `fsFillProcessIncompleteNotification`
         - `csCpuTemeratureCriticalNotification`
         - `csBattTempertureHighNotification`
         - `csCpuTemperatureHighNotification`
         - `csWcTemperatureHeighNotification`
         - `csBattFailNotification`
         - `csBattLowNotification`
         - `csWcErrorNotification`
         */
    func testNotifications() {
        expectedAlertPriority = .notDefined

        XCTAssertEqual(AlarmType.fsMalfuncionNotification.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(AlarmType.fsFillProcessInterruptedNotification.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(AlarmType.fsFillProcessIncompleteNotification.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(AlarmType.csCpuTemeratureCriticalNotification.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(AlarmType.csBattTempertureHighNotification.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(AlarmType.csCpuTemperatureHighNotification.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(AlarmType.csWcTemperatureHeighNotification.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(AlarmType.csBattFailNotification.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(AlarmType.csBattLowNotification.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(AlarmType.csWcErrorNotification.getAlertPriority(), expectedAlertPriority)
    }

    /**
         This method testing if method initWithIndex returns appropriate Alert value.

         Indexes and alerts:
         - 1 -->`pumpMalfunction`
         - 2 -->`emptyBattery`
         - 3 -->`emptyDrug`
         - 4 -->`drugExpired`
         - 5 -->`blockageDetected`
         - 6 -->`cartridgeDisconnected`
         - 7 -->`treatmentPausedTooLong`
         - 21 -->`treatmentPaused`
         - 22 -->`pumpBatteryLow`
         - 23 -->`drugDeliveryWillStopScan`
         - 30 -->`fsMalfuncionNotification`
         - 31 -->`fsFillProcessInterruptedNotification`
         - 32 -->`fsFillProcessIncompleteNotification`
         - 33 -->`csCpuTemeratureCriticalNotification`
         - 34 -->`csBattTempertureHighNotification`
         - 35 -->`csCpuTemperatureHighNotification`
         - 36 -->`csWcTemperatureHeighNotification`
         - 37 -->`csBattFailNotification`
         - 38 -->`csBattLowNotification`
         - 39 -->`csWcErrorNotification`
         */
    func testInitializationWithIndex() {
        XCTAssertEqual(AlarmType.pumpMalfunction, AlarmType.initFromIndex(index: 1))
        XCTAssertEqual(AlarmType.emptyBattery, AlarmType.initFromIndex(index: 2))
        XCTAssertEqual(AlarmType.emptyDrug, AlarmType.initFromIndex(index: 3))
        XCTAssertEqual(AlarmType.drugExpired, AlarmType.initFromIndex(index: 4))
        XCTAssertEqual(AlarmType.blockageDetected, AlarmType.initFromIndex(index: 5))
        XCTAssertEqual(AlarmType.cartridgeDisconnected, AlarmType.initFromIndex(index: 6))
        XCTAssertEqual(AlarmType.treatmentPausedTooLong, AlarmType.initFromIndex(index: 7))
        XCTAssertEqual(AlarmType.treatmentPaused, AlarmType.initFromIndex(index: 21))
        XCTAssertEqual(AlarmType.pumpBatteryLow, AlarmType.initFromIndex(index: 22))
        XCTAssertEqual(AlarmType.drugDeliveryWillStopScan, AlarmType.initFromIndex(index: 23))
        XCTAssertEqual(AlarmType.fsMalfuncionNotification, AlarmType.initFromIndex(index: 30))
        XCTAssertEqual(AlarmType.fsFillProcessInterruptedNotification, AlarmType.initFromIndex(index: 31))
        XCTAssertEqual(AlarmType.fsFillProcessIncompleteNotification, AlarmType.initFromIndex(index: 32))
        XCTAssertEqual(AlarmType.csCpuTemeratureCriticalNotification, AlarmType.initFromIndex(index: 33))
        XCTAssertEqual(AlarmType.csBattTempertureHighNotification, AlarmType.initFromIndex(index: 34))
        XCTAssertEqual(AlarmType.csCpuTemperatureHighNotification, AlarmType.initFromIndex(index: 35))
        XCTAssertEqual(AlarmType.csWcTemperatureHeighNotification, AlarmType.initFromIndex(index: 36))
        XCTAssertEqual(AlarmType.csBattFailNotification, AlarmType.initFromIndex(index: 37))
        XCTAssertEqual(AlarmType.csBattLowNotification, AlarmType.initFromIndex(index: 38))
        XCTAssertEqual(AlarmType.csWcErrorNotification, AlarmType.initFromIndex(index: 39))
    }

}
