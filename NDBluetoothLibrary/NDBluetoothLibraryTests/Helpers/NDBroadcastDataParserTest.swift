//
//  NDBroadcastDataParserTest.swift
//  NDBluetoothLibraryTests
//
//  Created by Digital Atrium on 16.6.21..
//
@testable import NDBluetoothLibrary
import XCTest

class NDBroadcastDataParserTest: XCTestCase {

    // MARK: - Pump data for different flows

    private let pumpDataBeforeFTUFlow = Data([0x00, 0x40, 0x64, 0x00, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x4A])
    private let pumpDataAfterFTUFlow = Data([0x03, 0x83, 0x3C, 0x40, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x4A])
    private let pumpDataAfterStartedDelivery = Data([0x00, 0x0B, 0x50, 0x40, 0x06, 0x00, 0x00, 0x0C, 0x36, 0x17, 0x00, 0x00, 0x4A])
    private let pumpDataInWD = Data([0x00, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x4A])
    private let pumpDataTreatmantPaused = Data([0x15, 0x83, 0x50, 0x40, 0x09, 0x00, 0x00, 0x0C, 0x30, 0x17, 0x03, 0x00, 0x4A])
    private let pumpDataCartrigeRemoved = Data([0x06, 0x41, 0x50, 0x40, 0x09, 0x00, 0x00, 0x0C, 0x2A, 0x17, 0x09, 0x00, 0x4A])
    private let pumpDataHardvareMulfunction = Data([0x3B, 0x41, 0x50, 0x40, 0x09, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x0C, 0x00, 0x4A])

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
         This method test parsing pump data before FTU flow is done.

         After setting input data: `[0x00, 0x40, 0x64, 0x00, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x4A]` pump status should create output:
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
    func testPumpDataBeforeFTUFlowDone() {
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

        let parsedPumpData = NDBroadcastDataParser.parseData(advertisementData: pumpDataBeforeFTUFlow)

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
         This method test parsing pump data after FTU flow is done.

         After setting input data: `[0x03, 0x83, 0x3C, 0x40, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x4A]` pump status should create output:
         - Alarm code: `3`
         - Alarm details code: `0`
         - Batery status: `60`
         - Active regimen flow: `0.64`
         - Deliver dose: `0.0`
         - Max deliver dose: `12.0`
         - Time until end of treatment: `0`
         - Time since duration stoped: `0`
         - Is FTU done: `true`
         - Cartridge attached: `true`
         - Coupled to the Station: `false`
         - Delivering medicine: `false`
         - Is in fill state: `false`
         - Is in full treatment flow: `false`
         - Is Cartridge Removed In Last Hour: `false`
         - Is Alarm Acknowledged: `true`
         */
    func testPumpDataAfterFTUFlowDone() {
        /// Pump expected values
        expectedAlarmCode = 3
        expectedAlarmDetailsCode = 0
        expectedBatteryStatus = 60
        expectedActiveRegimenFlow = 0.64
        expectedDeliverDose = 0.0
        expectedMaxDeliveredDose = 12.0
        expectedTimeUntilEndOfTreatment = 0
        expectedTimeSinceDurationStopped = 0

        /// Pump status expected values
        expectedPumpStatus = NDPumpStatus()
        expectedPumpStatus.isFtuDone = true
        expectedPumpStatus.cartridgeAttached = true
        expectedPumpStatus.coupledToStation = false
        expectedPumpStatus.deliveringMedicine = false
        expectedPumpStatus.inFillingState = false
        expectedPumpStatus.inFullTreatmentFlow = false
        expectedPumpStatus.isCartridgeRemovedInLastOneHour = false
        expectedPumpStatus.isAlarmAcknowledged = true

        let parsedPumpData = NDBroadcastDataParser.parseData(advertisementData: pumpDataAfterFTUFlow)

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
         This method test parsing pump data after started delivery.

         After setting input data: `[0x00, 0x0B, 0x50, 0x40, 0x06, 0x00, 0x00, 0x0C, 0x36, 0x17, 0x00, 0x00, 0x4A]` pump status should create output:
         - Alarm code: `0`
         - Alarm details code: `0`
         - Batery status: `80`
         - Active regimen flow: `0.64`
         - Deliver dose: `0.06`
         - Max deliver dose: `12.0`
         - Time until end of treatment: `2354`
         - Time since duration stoped: `0`
         - Is FTU done: `true`
         - Cartridge attached: `true`
         - Coupled to the Station: `false`
         - Delivering medicine: `true`
         - Is in fill state: `false`
         - Is in full treatment flow: `false`
         - Is Cartridge Removed In Last Hour: `false`
         - Is Alarm Acknowledged: `false`
         */
    func testPumpDataAfterStartedDelivery() {
        /// Pump expected values
        expectedAlarmCode = 0
        expectedAlarmDetailsCode = 0
        expectedBatteryStatus = 80
        expectedActiveRegimenFlow = 0.64
        expectedDeliverDose = 0.06
        expectedMaxDeliveredDose = 12.0
        expectedTimeUntilEndOfTreatment = 2354
        expectedTimeSinceDurationStopped = 0

        /// Pump status expected values
        expectedPumpStatus = NDPumpStatus()
        expectedPumpStatus.isFtuDone = true
        expectedPumpStatus.cartridgeAttached = true
        expectedPumpStatus.coupledToStation = false
        expectedPumpStatus.deliveringMedicine = true
        expectedPumpStatus.inFillingState = false
        expectedPumpStatus.inFullTreatmentFlow = false
        expectedPumpStatus.isCartridgeRemovedInLastOneHour = false
        expectedPumpStatus.isAlarmAcknowledged = false

        let parsedPumpData = NDBroadcastDataParser.parseData(advertisementData: pumpDataAfterStartedDelivery)

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
         This method test parsing pump data in WD.

         After setting input data: `[0x00, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x4A]` pump status should create output:
         - Alarm code: `0`
         - Alarm details code: `0`
         - Batery status: `0`
         - Active regimen flow: `0.0`
         - Deliver dose: `0.0`
         - Max deliver dose: `12.0`
         - Time until end of treatment: `0`
         - Time since duration stoped: `0`
         - Is FTU done: `true`
         - Cartridge attached: `true`
         - Coupled to the Station: `true`
         - Delivering medicine: `false`
         - Is in fill state: `false`
         - Is in full treatment flow: `false`
         - Is Cartridge Removed In Last Hour: `false`
         - Is Alarm Acknowledged: `false`
         */
    func testPumpDataInWD() {
        /// Pump expected values
        expectedAlarmCode = 0
        expectedAlarmDetailsCode = 0
        expectedBatteryStatus = 0
        expectedActiveRegimenFlow = 0.0
        expectedDeliverDose = 0.0
        expectedMaxDeliveredDose = 12.0
        expectedTimeUntilEndOfTreatment = 0
        expectedTimeSinceDurationStopped = 0

        /// Pump status expected values
        expectedPumpStatus = NDPumpStatus()
        expectedPumpStatus.isFtuDone = true
        expectedPumpStatus.cartridgeAttached = true
        expectedPumpStatus.coupledToStation = true
        expectedPumpStatus.deliveringMedicine = false
        expectedPumpStatus.inFillingState = false
        expectedPumpStatus.inFullTreatmentFlow = false
        expectedPumpStatus.isCartridgeRemovedInLastOneHour = false
        expectedPumpStatus.isAlarmAcknowledged = false

        let parsedPumpData = NDBroadcastDataParser.parseData(advertisementData: pumpDataInWD)

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
         This method test parsing pump data when treatment is paused.

         After setting input data: `[0x15, 0x83, 0x50, 0x40, 0x09, 0x00, 0x00, 0x0C, 0x30, 0x17, 0x03, 0x00, 0x4A]` pump status should create output:
         - Alarm code: `21`
         - Alarm details code: `0`
         - Batery status: `80`
         - Active regimen flow: `0.64`
         - Deliver dose: `0.09`
         - Max deliver dose: `12.0`
         - Time until end of treatment: `2348`
         - Time since duration stoped: `3`
         - Is FTU done: `true`
         - Cartridge attached: `true`
         - Coupled to the Station: `false`
         - Delivering medicine: `false`
         - Is in fill state: `false`
         - Is in full treatment flow: `false`
         - Is Cartridge Removed In Last Hour: `false`
         - Is Alarm Acknowledged: `true`
         */
    func testPumpDataTreatmantPaused() {
        /// Pump expected values
        expectedAlarmCode = 21
        expectedAlarmDetailsCode = 0
        expectedBatteryStatus = 80
        expectedActiveRegimenFlow = 0.64
        expectedDeliverDose = 0.09
        expectedMaxDeliveredDose = 12.0
        expectedTimeUntilEndOfTreatment = 2348
        expectedTimeSinceDurationStopped = 3

        /// Pump status expected values
        expectedPumpStatus = NDPumpStatus()
        expectedPumpStatus.isFtuDone = true
        expectedPumpStatus.cartridgeAttached = true
        expectedPumpStatus.coupledToStation = false
        expectedPumpStatus.deliveringMedicine = false
        expectedPumpStatus.inFillingState = false
        expectedPumpStatus.inFullTreatmentFlow = false
        expectedPumpStatus.isCartridgeRemovedInLastOneHour = false
        expectedPumpStatus.isAlarmAcknowledged = true

        let parsedPumpData = NDBroadcastDataParser.parseData(advertisementData: pumpDataTreatmantPaused)

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
         This method test parsing pump data when cartrige is removed.

         After setting input data: `[0x06, 0x41, 0x50, 0x40, 0x09, 0x00, 0x00, 0x0C, 0x2A, 0x17, 0x09, 0x00, 0x4A]` pump status should create output:
         - Alarm code: `6`
         - Alarm details code: `0`
         - Batery status: `80`
         - Active regimen flow: `0.64`
         - Deliver dose: `0.09`
         - Max deliver dose: `12.0`
         - Time until end of treatment: `2342`
         - Time since duration stoped: `9`
         - Is FTU done: `true`
         - Cartridge attached: `false`
         - Coupled to the Station: `false`
         - Delivering medicine: `false`
         - Is in fill state: `false`
         - Is in full treatment flow: `false`
         - Is Cartridge Removed In Last Hour: `true`
         - Is Alarm Acknowledged: `false`
         */
    func testPumpDataCartrigeRemoved() {
        /// Pump expected values
        expectedAlarmCode = 6
        expectedAlarmDetailsCode = 0
        expectedBatteryStatus = 80
        expectedActiveRegimenFlow = 0.64
        expectedDeliverDose = 0.09
        expectedMaxDeliveredDose = 12.0
        expectedTimeUntilEndOfTreatment = 2342
        expectedTimeSinceDurationStopped = 9

        /// Pump status expected values
        expectedPumpStatus = NDPumpStatus()
        expectedPumpStatus.isFtuDone = true
        expectedPumpStatus.cartridgeAttached = false
        expectedPumpStatus.coupledToStation = false
        expectedPumpStatus.deliveringMedicine = false
        expectedPumpStatus.inFillingState = false
        expectedPumpStatus.inFullTreatmentFlow = false
        expectedPumpStatus.isCartridgeRemovedInLastOneHour = true
        expectedPumpStatus.isAlarmAcknowledged = false

        let parsedPumpData = NDBroadcastDataParser.parseData(advertisementData: pumpDataCartrigeRemoved)

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
         This method test parsing pump data for hardvare mulfunction.

         After setting input data: `[0x3B, 0x41, 0x50, 0x40, 0x09, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x0C, 0x00, 0x4A]` pump status should create output:
         - Alarm code: `1`
         - Alarm details code: `29`
         - Batery status: `80`
         - Active regimen flow: `0.64`
         - Deliver dose: `0.09`
         - Max deliver dose: `12.0`
         - Time until end of treatment: `0`
         - Time since duration stoped: `12`
         - Is FTU done: `true`
         - Cartridge attached: `false`
         - Coupled to the Station: `false`
         - Delivering medicine: `false`
         - Is in fill state: `false`
         - Is in full treatment flow: `false`
         - Is Cartridge Removed In Last Hour: `true`
         - Is Alarm Acknowledged: `false`
         */
    func testPumpDataHardvareMalfunction() {
        /// Pump expected values
        expectedAlarmCode = 1
        expectedAlarmDetailsCode = 29
        expectedBatteryStatus = 80
        expectedActiveRegimenFlow = 0.64
        expectedDeliverDose = 0.09
        expectedMaxDeliveredDose = 12.0
        expectedTimeUntilEndOfTreatment = 0
        expectedTimeSinceDurationStopped = 12

        /// Pump status expected values
        expectedPumpStatus = NDPumpStatus()
        expectedPumpStatus.isFtuDone = true
        expectedPumpStatus.cartridgeAttached = false
        expectedPumpStatus.coupledToStation = false
        expectedPumpStatus.deliveringMedicine = false
        expectedPumpStatus.inFillingState = false
        expectedPumpStatus.inFullTreatmentFlow = false
        expectedPumpStatus.isCartridgeRemovedInLastOneHour = true
        expectedPumpStatus.isAlarmAcknowledged = false

        let parsedPumpData = NDBroadcastDataParser.parseData(advertisementData: pumpDataHardvareMulfunction)

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
}
