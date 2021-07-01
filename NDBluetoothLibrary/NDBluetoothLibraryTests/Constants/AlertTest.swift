//
//  AlertTest.swift
//  NDBluetoothLibraryTests
//
//  Created by Bojana Vojvodic on 30.6.21..
//
@testable import NDBluetoothLibrary
import XCTest

class AlertTest: XCTestCase {

    private var expectedAlertPriority = AlertPriority.noAlert

    /**
         This method testing if priority of noAlarm alert is noAlert.

         NoAlert  should be:
         - `noAlarm`
         */
    func testNoAlarmPriority() {
        expectedAlertPriority = .noAlert

        XCTAssertEqual(Alert.noAlarm.getAlertPriority(), expectedAlertPriority)
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

        XCTAssertEqual(Alert.pumpMalfunction.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(Alert.emptyBattery.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(Alert.emptyDrug.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(Alert.drugExpired.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(Alert.blockageDetected.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(Alert.cartridgeDisconnected.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(Alert.treatmentPausedTooLong.getAlertPriority(), expectedAlertPriority)
    }

    /**
         This method testing if all medium priority alarms returns `medium` for priority type..

         Medium priority alarms should be:
         - `treatmentPaused`
         */
    func testMediumAlertPriority() {
        expectedAlertPriority = .medium

        XCTAssertEqual(Alert.treatmentPaused.getAlertPriority(), expectedAlertPriority)
    }

    /**
         This method testing if all low priority alarms returns `low` for priority type..

         Low priority alarms should be:
         - `pumpBatteryLow`
         - `drugDeliveryWillStopScan`
         */
    func testLowAlertPriority() {
        expectedAlertPriority = .low

        XCTAssertEqual(Alert.pumpBatteryLow.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(Alert.drugDeliveryWillStopScan.getAlertPriority(), expectedAlertPriority)
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

        XCTAssertEqual(Alert.fsMalfuncionNotification.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(Alert.fsFillProcessInterruptedNotification.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(Alert.fsFillProcessIncompleteNotification.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(Alert.csCpuTemeratureCriticalNotification.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(Alert.csBattTempertureHighNotification.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(Alert.csCpuTemperatureHighNotification.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(Alert.csWcTemperatureHeighNotification.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(Alert.csBattFailNotification.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(Alert.csBattLowNotification.getAlertPriority(), expectedAlertPriority)
        XCTAssertEqual(Alert.csWcErrorNotification.getAlertPriority(), expectedAlertPriority)
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
        XCTAssertEqual(Alert.pumpMalfunction, Alert.initFromIndex(index: 1))
        XCTAssertEqual(Alert.emptyBattery, Alert.initFromIndex(index: 2))
        XCTAssertEqual(Alert.emptyDrug, Alert.initFromIndex(index: 3))
        XCTAssertEqual(Alert.drugExpired, Alert.initFromIndex(index: 4))
        XCTAssertEqual(Alert.blockageDetected, Alert.initFromIndex(index: 5))
        XCTAssertEqual(Alert.cartridgeDisconnected, Alert.initFromIndex(index: 6))
        XCTAssertEqual(Alert.treatmentPausedTooLong, Alert.initFromIndex(index: 7))
        XCTAssertEqual(Alert.treatmentPaused, Alert.initFromIndex(index: 21))
        XCTAssertEqual(Alert.pumpBatteryLow, Alert.initFromIndex(index: 22))
        XCTAssertEqual(Alert.drugDeliveryWillStopScan, Alert.initFromIndex(index: 23))
        XCTAssertEqual(Alert.fsMalfuncionNotification, Alert.initFromIndex(index: 30))
        XCTAssertEqual(Alert.fsFillProcessInterruptedNotification, Alert.initFromIndex(index: 31))
        XCTAssertEqual(Alert.fsFillProcessIncompleteNotification, Alert.initFromIndex(index: 32))
        XCTAssertEqual(Alert.csCpuTemeratureCriticalNotification, Alert.initFromIndex(index: 33))
        XCTAssertEqual(Alert.csBattTempertureHighNotification, Alert.initFromIndex(index: 34))
        XCTAssertEqual(Alert.csCpuTemperatureHighNotification, Alert.initFromIndex(index: 35))
        XCTAssertEqual(Alert.csWcTemperatureHeighNotification, Alert.initFromIndex(index: 36))
        XCTAssertEqual(Alert.csBattFailNotification, Alert.initFromIndex(index: 37))
        XCTAssertEqual(Alert.csBattLowNotification, Alert.initFromIndex(index: 38))
        XCTAssertEqual(Alert.csWcErrorNotification, Alert.initFromIndex(index: 39))
    }

}
