//
//  CharacteristicTypeTests.swift
//  NDBluetoothLibraryTests
//
//  Created by Digital Atrium on 30.6.21..
//
@testable import NDBluetoothLibrary
import XCTest

class CharacteristicTypeTests: XCTestCase {

    private var expectedIsReadable = true
    private var expectedIsWritable = true
    private var expectedIsNotifyCharacteristics = true
    private var expectedPriority = 1
    private var expectedCharacteristicsArray: [CharacteristicType] = [.clockSynchronization, .pumpStatusRegister, .batteryLevel, .medicineStatus, .pumpAlarm, .treatmentControlTime, .infusionSetPrimingValue, .pumpCommand, .pumpTest, .pumpInternalFlagsAndTemperature, .pumpStatistics
    ]

    /**
         This method testing if all readable characteristics returns true for read property type.

         Readable characteristics should be:
        - `clockSynchronization`
        - `pumpStatusRegister`
        - `batteryLevel`
        - `medicineStatus`
        - `pumpAlarm`
        - `treatmentControlTime`
        - `infusionSetPrimingValue`
        - `pumpTest`
        - `pumpInternalFlagsAndTemperature`
        - `pumpStatistics`
        - `pumpBroadcastDecryptionKey`
        - `pumpVersionCode`
        - `logSize`
        - `log`
        - `regimenSize`
        - `regimenPointer`
        - `regimenSegmentPointer`
        - `regimenSegmentTime`
        - `regimenSegmentValue`
        - `numberOfSegmentsInRegimen`
        - `activeRegimenIndex`
        - `currentMedicineFlow`
        - `deliveredDose`
        - `regimenSetupMinimumValue`
        - `regimenSetupMaximumValue`
        - `maximumDailyDoseValue`
        - `regimenCrcValue`
         */
    func testReadableCharacteristics() {
        XCTAssertEqual(CharacteristicType.clockSynchronization.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.pumpStatusRegister.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.batteryLevel.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.medicineStatus.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.pumpAlarm.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.treatmentControlTime.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.infusionSetPrimingValue.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.pumpTest.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.pumpInternalFlagsAndTemperature.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.pumpStatistics.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.pumpBroadcastDecryptionKey.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.pumpVersionCode.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.logSize.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.log.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.regimenSize.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.regimenPointer.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.regimenSegmentPointer.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.regimenSegmentTime.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.regimenSegmentValue.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.numberOfSegmentsInRegimen.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.activeRegimenIndex.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.currentMedicineFlow.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.deliveredDose.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.regimenSetupMinimumValue.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.regimenSetupMaximumValue.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.maximumDailyDoseValue.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.regimenCrcValue.read, expectedIsReadable)
    }

    /**
         This method testing if all non readable characteristics returns false for read property type.

         Readable characteristics should be:
        - `pumpCommand`
        - `selectPump`
        - `startAuthentication`
         */
    func testNotReadableCharacteristics() {
        expectedIsReadable = false

        XCTAssertEqual(CharacteristicType.selectPump.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.pumpCommand.read, expectedIsReadable)
        XCTAssertEqual(CharacteristicType.startAuthentication.read, expectedIsReadable)
    }

    /**
         This method testing if all writable characteristics returns true for write property type.

         Writable characteristics should be:
        - `clockSynchronization`
        - `infusionSetPrimingValue`
        - `pumpCommand`
        - `startAuthentication`
        - `selectPump`
        - `regimenPointer`
        - `regimenSegmentPointer`
        - `regimenSegmentTime`
        - `regimenSegmentValue`
        - `clearSelectedRegimen`
        - `activeRegimenIndex`
        - `regimenCrcValue`
         */
    func testWritableCharacteristics() {
        XCTAssertEqual(CharacteristicType.clockSynchronization.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.infusionSetPrimingValue.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.pumpCommand.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.startAuthentication.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.selectPump.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.regimenPointer.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.regimenSegmentPointer.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.regimenSegmentTime.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.regimenSegmentValue.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.clearSelectedRegimen.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.activeRegimenIndex.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.regimenCrcValue.write, expectedIsWritable)
    }

    /**
         This method testing if all non writable characteristics returns false for write property type.

         Not writable characteristics should be:
        - `pumpStatusRegister`
        - `batteryLevel`
        - `medicineStatus`
        - `pumpAlarm`
        - `treatmentControlTime`
        - `pumpTest`
        - `pumpInternalFlagsAndTemperature`
        - `pumpStatistics`
        - `pumpBroadcastDecryptionKey`
        - `pumpVersionCode`
        - `logSize`
        - `log`
        - `regimenSize`
        - `numberOfSegmentsInRegimen`
        - `currentMedicineFlow`
        - `deliveredDose`
        - `regimenSetupMinimumValue`
        - `regimenSetupMaximumValue`
        - `maximumDailyDoseValue`
         */
    func testNonWritableCharacteristics() {
        expectedIsWritable = false

        XCTAssertEqual(CharacteristicType.pumpStatusRegister.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.batteryLevel.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.medicineStatus.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.pumpAlarm.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.treatmentControlTime.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.pumpTest.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.pumpInternalFlagsAndTemperature.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.pumpStatistics.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.pumpBroadcastDecryptionKey.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.pumpVersionCode.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.logSize.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.log.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.regimenSize.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.numberOfSegmentsInRegimen.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.currentMedicineFlow.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.deliveredDose.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.regimenSetupMinimumValue.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.regimenSetupMaximumValue.write, expectedIsWritable)
        XCTAssertEqual(CharacteristicType.maximumDailyDoseValue.write, expectedIsWritable)
    }

    /**
         This method testing if all characteristics whitch have notify option returns true for notify property type.

         Notify characteristics should be:
        - `pumpStatusRegister`
        - `batteryLevel`
        - `medicineStatus`
        - `pumpAlarm`
        - `treatmentControlTime`
        - `pumpTest`
        - `pumpInternalFlagsAndTemperature`
        - `pumpStatistics`
        - `log`
        - `startAuthentication`
        - `regimenCrcValue`
         */
    func testNotifyCharacteristics() {
        XCTAssertEqual(CharacteristicType.pumpStatusRegister.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.batteryLevel.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.medicineStatus.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.pumpAlarm.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.treatmentControlTime.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.pumpTest.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.pumpInternalFlagsAndTemperature.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.pumpStatistics.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.startAuthentication.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.regimenCrcValue.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.log.notify, expectedIsNotifyCharacteristics)
    }

    /**
     This method testing if all characteristics whitch do not have notify option returns false for notify property type.

     Non notify characteristics should be:
        - `pumpBroadcastDecryptionKey`
        - `pumpVersionCode`
        - `logSize`
        - `regimenSize`
        - `regimenPointer`
        - `regimenSegmentPointer`
        - `regimenSegmentTime`
        - `regimenSegmentValue`
        - `numberOfSegmentsInRegimen`
        - `activeRegimenIndex`
        - `currentMedicineFlow`
        - `deliveredDose`
        - `regimenSetupMinimumValue`
        - `regimenSetupMaximumValue`
        - `maximumDailyDoseValue`
        - `pumpCommand`
        - `selectPump`
         */
    func testNonNotifyCharacteristics() {
        expectedIsNotifyCharacteristics = false

        XCTAssertEqual(CharacteristicType.pumpBroadcastDecryptionKey.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.pumpVersionCode.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.logSize.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.regimenSize.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.regimenPointer.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.regimenSegmentPointer.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.regimenSegmentTime.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.regimenSegmentValue.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.numberOfSegmentsInRegimen.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.activeRegimenIndex.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.currentMedicineFlow.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.deliveredDose.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.regimenSetupMinimumValue.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.regimenSetupMaximumValue.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.maximumDailyDoseValue.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.selectPump.notify, expectedIsNotifyCharacteristics)
        XCTAssertEqual(CharacteristicType.pumpCommand.notify, expectedIsNotifyCharacteristics)
    }

    /**
         This method testing if priority of all characteristics type whitch need to have priority one returns 1 for property priority.

         Characteristics with priority one should be:
        - `clockSynchronization`
        - `pumpStatusRegister`
        - `batteryLevel`
        - `medicineStatus`
        - `treatmentControlTime`
        - `infusionSetPrimingValue`
        - `pumpTest`
        - `pumpInternalFlagsAndTemperature`
        - `pumpStatistics`
        - `pumpBroadcastDecryptionKey`
        - `pumpVersionCode`
        - `logSize`
        - `log`
        - `regimenSize`
        - `regimenPointer`
        - `regimenSegmentPointer`
        - `regimenSegmentTime`
        - `regimenSegmentValue`
        - `numberOfSegmentsInRegimen`
        - `activeRegimenIndex`
        - `currentMedicineFlow`
        - `deliveredDose`
        - `regimenSetupMinimumValue`
        - `regimenSetupMaximumValue`
        - `maximumDailyDoseValue`
        - `regimenCrcValue`
         */
    func testPriorityOneCharacteristics() {
        XCTAssertEqual(CharacteristicType.clockSynchronization.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.batteryLevel.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.medicineStatus.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.treatmentControlTime.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.infusionSetPrimingValue.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.pumpTest.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.pumpInternalFlagsAndTemperature.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.pumpStatistics.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.pumpBroadcastDecryptionKey.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.logSize.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.log.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.regimenSize.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.regimenPointer.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.regimenSegmentPointer.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.regimenSegmentTime.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.regimenSegmentValue.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.activeRegimenIndex.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.currentMedicineFlow.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.deliveredDose.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.regimenSetupMinimumValue.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.regimenSetupMaximumValue.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.maximumDailyDoseValue.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.regimenCrcValue.priority, expectedPriority)
    }

    /**
         This method testing if all characteristics with priority 1000 returns 1000 as a value of priority field.

         Characteristics fith prioryty 1000 should be:
        - `startAuthentication`
         */
    func testPriority1000Characteristics() {
        expectedPriority = 1000

        XCTAssertEqual(CharacteristicType.startAuthentication.priority, expectedPriority)
    }

    /**
         This method testing if all characteristics with priority 999 returns 999 as a value of priority field.

         Characteristics fith prioryty 999 should be:
        - `pumpVersionCode`
         */
    func testPriority999Characteristics() {
        expectedPriority = 999

        XCTAssertEqual(CharacteristicType.pumpVersionCode.priority, expectedPriority)
    }

    /**
         This method testing if all characteristics with priority 998 returns 998 as a value of priority field.

         Characteristics fith prioryty 998 should be:
        - `pumpAlarm`
        - `pumpStatusRegister`
         */
    func testPriority998Characteristics() {
        expectedPriority = 998

        XCTAssertEqual(CharacteristicType.pumpAlarm.priority, expectedPriority)
        XCTAssertEqual(CharacteristicType.pumpStatusRegister.priority, expectedPriority)
    }

    /**
         This method testing getting array of characteristis for specified servis type returns correct value.

         Characteristics for .pump servis type should be:
        - `clockSynchronization`
        - `pumpStatusRegister`
        - `batteryLevel`
        - `medicineStatus`
        - `treatmentControlTime`
        - `infusionSetPrimingValue`
        - `pumpTest`
        - `pumpInternalFlagsAndTemperature`
        - `pumpStatistics`
        - `pumpCommand`
         */
    func testCharacteristicsArrayForPumpServiceType() {
        XCTAssertEqual(CharacteristicType.characteristics(forServiceType: .pump), expectedCharacteristicsArray)
    }

    /**
         This method testing getting array of characteristis for specified servis type returns correct value.

         Characteristics for .general servis type should be:
        - `pumpBroadcastDecryptionKey`
        - `startAuthentication`
        - `selectPump`
        - `pumpVersionCode`
         */
    func testCharacteristicsArrayForGeneralServiceType() {
        expectedCharacteristicsArray = [.pumpBroadcastDecryptionKey, .startAuthentication, .selectPump, .pumpVersionCode]
        XCTAssertEqual(CharacteristicType.characteristics(forServiceType: .general), expectedCharacteristicsArray)
    }

    /**
         This method testing getting array of characteristis for specified servis type returns correct value.

         Characteristics for .log servis type should be:
        - `logSize`
        - `log`
         */
    func testCharacteristicsArrayForLogServiceType() {
        expectedCharacteristicsArray = [.logSize, .log]

        XCTAssertEqual(CharacteristicType.characteristics(forServiceType: .log), expectedCharacteristicsArray)
    }

    /**
         This method testing getting array of characteristis for specified servis type returns correct value.

         Characteristics for .regimen servis type should be:
        - `regimenSize`
        - `regimenPointer`
        - `regimenSegmentPointer`
        - `regimenSegmentTime`
        - `regimenSegmentValue`
        - `clearSelectedRegimen`
        - `numberOfSegmentsInRegimen`
        - `activeRegimenIndex`
        - `currentMedicineFlow`
        - `deliveredDose`
        - `regimenSetupMinimumValue`
        - `regimenSetupMaximumValue`
        - `maximumDailyDoseValue`
        - `regimenCrcValue`
         */
    func testCharacteristicsArrayForRegimenServiceType() {
        expectedCharacteristicsArray = [.regimenSize, .regimenPointer, .regimenSegmentPointer, .regimenSegmentTime, .regimenSegmentValue, .clearSelectedRegimen, .numberOfSegmentsInRegimen, .activeRegimenIndex, .currentMedicineFlow, .deliveredDose, .regimenSetupMinimumValue, .regimenSetupMaximumValue, .maximumDailyDoseValue, .regimenCrcValue]

        XCTAssertEqual(CharacteristicType.characteristics(forServiceType: .regimen), expectedCharacteristicsArray)
    }

    /**
         This method testing getting array of characteristis for specified servis type returns correct value.

         Characteristics for .genericAttributeProfile servis type should be:
        - `[]` --> empty array
         */
    func testCharacteristicsArrayForGenericAttributeProfileServiceType() {
        expectedCharacteristicsArray = []

        XCTAssertEqual(CharacteristicType.characteristics(forServiceType: .genericAttributeProfile), expectedCharacteristicsArray)
    }

}
