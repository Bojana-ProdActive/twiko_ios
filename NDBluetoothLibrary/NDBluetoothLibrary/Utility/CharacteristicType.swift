////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// CharacteristicType.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        31.5.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
enum CharacteristicType: String, CaseIterable {

    // MARK: - Pump service characteristics

    case clockSynchronization = "89FBD001-476A-4E5B-9FCF-58BE6B43C623"
    case pumpStatusRegister = "89FBD020-476A-4E5B-9FCF-58BE6B43C623"
    case batteryLevel = "89FBD003-476A-4E5B-9FCF-58BE6B43C623"
    case medicineStatus = "89FBD007-476A-4E5B-9FCF-58BE6B43C623"
    case pumpAlarm = "89FBD010-476A-4E5B-9FCF-58BE6B43C623"
    case treatmentControlTime = "89FBD015-476A-4E5B-9FCF-58BE6B43C623"
    case infusionSetPrimingValue = "89FBD019-476A-4E5B-9FCF-58BE6B43C623"
    case pumpCommand = "89FBD021-476A-4E5B-9FCF-58BE6B43C623"
    case pumpTest = "89FBD022-476A-4E5B-9FCF-58BE6B43C623"
    case pumpInternalFlagsAndTemperature = "89FBD023-476A-4E5B-9FCF-58BE6B43C623"
    case pumpStatistics = "55955632-4917-46A3-A155-94DD5B610BE0"

    // MARK: - General service characteristics

    case pumpBroadcastDecryptionKey = "AFD04001-C496-4D71-96C6-25136C7D7339"
    case startAuthentication = "AFD04004-C496-4D71-96C6-25136C7D7339"
    case selectPump = "AFD04003-C496-4D71-96C6-25136C7D7339"
    case pumpVersionCode = "AFD04005-C496-4D71-96C6-25136C7D7339"

    // MARK: - Log service characteristics

    case logSize = "59715001-A757-4879-9E1E-B843F85E672F"
    case log = "59715005-A757-4879-9E1E-B843F85E672F"

    // MARK: - Regimen service characteristics

    case regimenSize = "263F7002-5CFC-4DB5-927B-2F670FDCBCBB"
    case regimenPointer = "263F7003-5CFC-4DB5-927B-2F670FDCBCBB"
    case regimenSegmentPointer = "263F7006-5CFC-4DB5-927B-2F670FDCBCBB"
    case regimenSegmentTime = "263F7007-5CFC-4DB5-927B-2F670FDCBCBB"
    case regimenSegmentValue = "263F7008-5CFC-4DB5-927B-2F670FDCBCBB"
    case clearSelectedRegimen = "263F7010-5CFC-4DB5-927B-2F670FDCBCBB"
    case selectedRegimenSize = "263F7011-5CFC-4DB5-927B-2F670FDCBCBB"
    case activeRegimenIndex = "263F7012-5CFC-4DB5-927B-2F670FDCBCBB"
    case currentMedicineFlow = "263F7014-5CFC-4DB5-927B-2F670FDCBCBB"
    case deliveredDose = "263F7015-5CFC-4DB5-927B-2F670FDCBCBB"
    case regimenSetupMinimumValue = "263F7017-5CFC-4DB5-927B-2F670FDCBCBB"
    case regimenSetupMaximumValue = "263F7018-5CFC-4DB5-927B-2F670FDCBCBB"
    case maximumDailyDoseValue = "263F7019-5CFC-4DB5-927B-2F670FDCBCBB"
    case regimenCrcValue = "263F7009-5CFC-4DB5-927B-2F670FDCBCBB"
}

extension CharacteristicType {

    var read: Bool {
        switch self {
        case .clockSynchronization,
             .pumpStatusRegister,
             .batteryLevel,
             .medicineStatus,
             .pumpAlarm,
             .treatmentControlTime,
             .infusionSetPrimingValue,
             .pumpTest,
             .pumpInternalFlagsAndTemperature,
             .pumpStatistics,
             .pumpBroadcastDecryptionKey,
             .pumpVersionCode,
             .logSize,
             .log,
             .regimenSize,
             .regimenPointer,
             .regimenSegmentPointer,
             .regimenSegmentTime,
             .regimenSegmentValue,
             .selectedRegimenSize,
             .activeRegimenIndex,
             .currentMedicineFlow,
             .deliveredDose,
             .regimenSetupMinimumValue,
             .regimenSetupMaximumValue,
             .maximumDailyDoseValue,
             .regimenCrcValue:
            return true
        default:
            return false
        }
    }

    var write: Bool {
        switch self {
        case .clockSynchronization,
             .infusionSetPrimingValue,
             .pumpCommand,
             .startAuthentication,
             .selectPump,
             .regimenPointer,
             .regimenSegmentPointer,
             .regimenSegmentTime,
             .regimenSegmentValue,
             .clearSelectedRegimen,
             .activeRegimenIndex,
             .regimenCrcValue:
            return true
        default:
            return false
        }
    }

    var notify: Bool {
        switch self {
        case .pumpStatusRegister,
             .batteryLevel,
             .medicineStatus,
             .pumpAlarm,
             .treatmentControlTime,
             .pumpTest,
             .pumpInternalFlagsAndTemperature,
             .pumpStatistics,
             .log,
             .startAuthentication,
             .regimenCrcValue:
            return true
        default:
            return false
        }
    }

    var priority: Int {
        switch self {
        case .startAuthentication:
            return 1000
        case .pumpVersionCode:
            return 999
        case .pumpAlarm,
             .pumpStatusRegister:
            return 998
        case .clockSynchronization,
             .batteryLevel,
             .medicineStatus,
             .treatmentControlTime,
             .infusionSetPrimingValue,
             .pumpCommand,
             .pumpTest,
             .pumpInternalFlagsAndTemperature,
             .pumpStatistics,
             .pumpBroadcastDecryptionKey,
             .selectPump,
             .logSize,
             .log,
             .regimenSize,
             .regimenPointer,
             .regimenSegmentPointer,
             .regimenSegmentTime,
             .regimenSegmentValue,
             .clearSelectedRegimen,
             .selectedRegimenSize,
             .activeRegimenIndex,
             .currentMedicineFlow,
             .deliveredDose,
             .regimenSetupMinimumValue,
             .regimenSetupMaximumValue,
             .maximumDailyDoseValue,
             .regimenCrcValue:
            return 1
        }
    }

    static func characteristics(forServiceType type: ServiceType) -> [CharacteristicType] {
        switch type {
        case .pump:
            return [
                .clockSynchronization,
                .pumpStatusRegister,
                .batteryLevel,
                .medicineStatus,
                .pumpAlarm,
                .treatmentControlTime,
                .infusionSetPrimingValue,
                .pumpCommand,
                .pumpTest,
                .pumpInternalFlagsAndTemperature,
                .pumpStatistics
            ]
        case .general:
            return [
                .pumpBroadcastDecryptionKey,
                .startAuthentication ,
                .selectPump,
                .pumpVersionCode
            ]
        case .log:
            return [
                .logSize,
                .log
            ]
        case .regimen:
            return [
                .regimenSize,
                .regimenPointer,
                .regimenSegmentPointer,
                .regimenSegmentTime,
                .regimenSegmentValue,
                .clearSelectedRegimen,
                .selectedRegimenSize,
                .activeRegimenIndex,
                .currentMedicineFlow,
                .deliveredDose,
                .regimenSetupMinimumValue,
                .regimenSetupMaximumValue,
                .maximumDailyDoseValue,
                .regimenCrcValue
            ]
        }
    }

    static func characteristicType(withUuidString uuidString: String) -> CharacteristicType? {
        return CharacteristicType.allCases.first { type in
            return type.rawValue.uppercased() == uuidString.uppercased()
        }
    }
}
