//
//  NDPumpTest.swift
//  NDBluetoothLibraryTests
//
//  Created by Digital Atrium on 16.6.21..
//
@testable import NDBluetoothLibrary
import XCTest

class NDPumpTest: XCTestCase {

    // MARK: - Pump data for different flows

    private let pumpData = Data([0x00, 0x40, 0x64, 0x00, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x4A])

    // MARK: - Expected values

    private var expectedAlarmCode: UInt8 = 0
    private var expectedAlarmDetailsCode: UInt8 = 0
    private var expectedBatteryStatus: UInt8 = 0
    private var expectedActiveRegimenFlow: Float = 0.0
    private var expectedDeliverDose: Float = 0.0
    private var expectedMaxDeliveredDose: Float = 0.0
    private var expectedPumpStatus: NDPumpStatus = NDPumpStatus()
    private var expectedTimeUntilEndOfTreatment: Int = 0
    private var expectedTimeSinceDurationStopped: Int = 0

    /**
         This method test set pump data.

         After setting input data: `[0x00, 0x40, 0x64, 0x00, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x4A` pump status should create output:
         - Alarm code: `0`
         - Alarm details code: `0`
         - Batery status: `100`
         - Active regimen flow: `0.0`
         - Deliver dose: `0.0`
         - Max deliver dose: `12.0`
         - Time until end of treatment: `0`
         - Time since duration stoped: `0`
         - Is FTU done: `false`
         - Cartridge attached: `false`
         - Coupled to the Station: `false`
         - Delivering medicine: `false`
         - Is in fill state: `false`
         - Is in full treatment flow: `false`
         - Is Cartridge Removed In Last Hour: `true`
         - Is Alarm Acknowledged: `false`
         */
    func testSetPumpData() {
        /// Pump expected value
        expectedAlarmCode = 0
        expectedAlarmDetailsCode = 0
        expectedBatteryStatus = 100
        expectedActiveRegimenFlow = 0.0
        expectedDeliverDose = 0.0
        expectedMaxDeliveredDose = 12.0
        expectedTimeUntilEndOfTreatment = 0
        expectedTimeSinceDurationStopped = 0

        /// Pump status expected values
        expectedPumpStatus = NDPumpStatus()
        expectedPumpStatus.isFtuDone = false
        expectedPumpStatus.cartridgeAttached = false
        expectedPumpStatus.coupledToStation = false
        expectedPumpStatus.deliveringMedicine = false
        expectedPumpStatus.inFillingState = false
        expectedPumpStatus.inFullTreatmentFlow = false
        expectedPumpStatus.isCartridgeRemovedInLastOneHour = true
        expectedPumpStatus.isAlarmAcknowledged = false

        let parsedPumpData = NDBroadcastDataParser.parseData(advertisementData: pumpData)

        // Test Pump data
        XCTAssertEqual(parsedPumpData?.alarmCode, expectedAlarmCode)
        XCTAssertEqual(parsedPumpData?.alarmDetailsCode, expectedAlarmDetailsCode)
        XCTAssertEqual(parsedPumpData?.batteryStatus, expectedBatteryStatus)
        XCTAssertEqual(parsedPumpData?.activeRegimenFlow, expectedActiveRegimenFlow)
        XCTAssertEqual(parsedPumpData?.deliverDose, expectedDeliverDose)
        XCTAssertEqual(parsedPumpData?.maxDeliveredDose, expectedMaxDeliveredDose)
        XCTAssertEqual(parsedPumpData?.timeUntilEndOfTreatment, expectedTimeUntilEndOfTreatment)
        XCTAssertEqual(parsedPumpData?.timeSinceDurationStopped, expectedTimeSinceDurationStopped)

        // Test Pump status data
        XCTAssertEqual(parsedPumpData?.pumpStatus?.isFtuDone, expectedPumpStatus.isFtuDone)
        XCTAssertEqual(parsedPumpData?.pumpStatus?.isAlarmAcknowledged, expectedPumpStatus.isAlarmAcknowledged)
        XCTAssertEqual(parsedPumpData?.pumpStatus?.cartridgeAttached, expectedPumpStatus.cartridgeAttached)
        XCTAssertEqual(parsedPumpData?.pumpStatus?.isCartridgeRemovedInLastOneHour, expectedPumpStatus.isCartridgeRemovedInLastOneHour)
        XCTAssertEqual(parsedPumpData?.pumpStatus?.coupledToStation, expectedPumpStatus.coupledToStation)
        XCTAssertEqual(parsedPumpData?.pumpStatus?.inFillingState, expectedPumpStatus.inFillingState)
        XCTAssertEqual(parsedPumpData?.pumpStatus?.deliveringMedicine, expectedPumpStatus.deliveringMedicine)
        XCTAssertEqual(parsedPumpData?.pumpStatus?.inFullTreatmentFlow, expectedPumpStatus.inFullTreatmentFlow)
    }

    /**
         This method test set equal function for same pump data.

         After setting same input data for Pump one and Pump Two: `[0x00, 0x40, 0x64, 0x00, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x4A` equals function should return true:
         - Alarm code: `0`
         - Alarm details code: `0`
         - Batery status: `200`
         - Active regimen flow: `0.0`
         - Deliver dose: `0.50`
         - Max deliver dose: `12.0`
         - Time until end of treatment: `0`
         - Time since duration stoped: `0`
         - Is FTU done: `false`
         - Cartridge attached: `true`
         - Coupled to the Station: `true`
         - Delivering medicine: `true`
         - Is in fill state: `true`
         - Is in full treatment flow: `true`
         - Is Cartridge Removed In Last Hour: `true`
         - Is Alarm Acknowledged: `true`
         */
    func testEqualFunction() {
        /// Set first pump data
        let pumpOne = NDPump()
        pumpOne.alarmCode = 0
        pumpOne.alarmDetailsCode = 0
        pumpOne.activeRegimenFlow = 0.0
        pumpOne.batteryStatus = 20
        pumpOne.deliverDose = 0.50
        pumpOne.maxDeliveredDose = 12.0
        let pumpStatusOne = NDPumpStatus()

        pumpStatusOne.isFtuDone = false
        pumpStatusOne.cartridgeAttached = true
        pumpStatusOne.inFillingState = true
        pumpStatusOne.inFullTreatmentFlow = true
        pumpStatusOne.isAlarmAcknowledged = true
        pumpStatusOne.isCartridgeRemovedInLastOneHour = true
        pumpStatusOne.coupledToStation = true
        pumpStatusOne.deliveringMedicine = true
        pumpOne.pumpStatus = pumpStatusOne

        let pumpTwo = NDPump()
        pumpTwo.alarmCode = 0
        pumpTwo.alarmDetailsCode = 0
        pumpTwo.activeRegimenFlow = 0.0
        pumpTwo.batteryStatus = 20
        pumpTwo.deliverDose = 0.50
        pumpTwo.maxDeliveredDose = 12.0
        let pumpStatusTwo = NDPumpStatus()

        pumpStatusTwo.isFtuDone = false
        pumpStatusTwo.cartridgeAttached = true
        pumpStatusTwo.inFillingState = true
        pumpStatusTwo.inFullTreatmentFlow = true
        pumpStatusTwo.isAlarmAcknowledged = true
        pumpStatusTwo.isCartridgeRemovedInLastOneHour = true
        pumpStatusTwo.coupledToStation = true
        pumpStatusTwo.deliveringMedicine = true
        pumpTwo.pumpStatus = pumpStatusTwo

        XCTAssertTrue(pumpOne == pumpTwo)
    }

    /**
         This method test equal function for different data.

         Equals function shoud be false after setting input data value for two pumps:

            Pump One:
            - Alarm code: `1`
            - Alarm details code: `9`

            Pump Two:
            - Alarm code: `0`
            - Alarm details code: `0`
         */
    func testNonEqualFunction() {
        /// Set first pump data
        let pumpOne = NDPump()
        pumpOne.alarmCode = 1
        pumpOne.alarmDetailsCode = 9
        let pumpStatusOne = NDPumpStatus()
        pumpOne.pumpStatus = pumpStatusOne

        let pumpTwo = NDPump()
        pumpTwo.alarmCode = 0
        pumpTwo.alarmDetailsCode = 0
        let pumpStatusTwo = NDPumpStatus()
        pumpTwo.pumpStatus = pumpStatusTwo

        XCTAssertFalse(pumpOne == pumpTwo)
    }

}
