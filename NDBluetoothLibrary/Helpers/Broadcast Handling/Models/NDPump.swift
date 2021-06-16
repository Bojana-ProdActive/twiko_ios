////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// NDPump.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        9.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
enum NDPumpBaseUnit: String, Codable {
    case miliLiters = "ml"
    case microLiters = "ul"

    /// Get default type
    static func getDefaultUnit() -> NDPumpBaseUnit {
        return NDPumpBaseUnit.microLiters
    }

    static func getDefaultUnitTextRegimenFlow() -> String {
        return "ml/h"
    }

    static func getDefaultUnitTextDeliverDose() -> String {
        return "mg"
    }

    static func getDefaultUnitTextMaxDeliveredDose() -> String {
        return "mg"
    }
}

final class NDPump: Codable, Equatable {

    var alarmCode: UInt8?
    var alarmDetailsCode: UInt8?
    var timeUntilCartridgeReplacement: Int?
    var batteryStatus: UInt8?
    var activeRegimenFlow: Float?
    var deliverDose: Float?
    var maxDeliveredDose: Float?
    var pumpName: String?
    var pumpStatus: NDPumpStatus?
    var timeUntilEndOfTreatment: Int?
    var timeSinceDurationStopped: Int?

    var rawData: Data?
    var unit: NDPumpBaseUnit?

    var device: String = "" // Mac address of pheripheral

    // MARK: - Coding keys

    private enum CodingKeys: String, CodingKey {
        case alarmCode = "alarm_code"
        case alarmDetailsCode = "alarm_details_code"
        case timeUntilCartridgeReplacement = "time_until_cartridge_replacement"
        case batteryStatus = "battery_status"
        case activeRegimenFlow = "active_regimen_flow"
        case deliverDose = "deliver_dose"
        case maxDeliveredDose = "max_delivered_dose"
        case pumpName = "pump_name"
        case pumpStatus = "status_register"
        case timeUntilEndOfTreatment = "time_until_end_of_treatment"
        case timeSinceDurationStopped = "time_since_duration_stopped"
        case rawData = "kRawData"
        case unit = "unit"
    }

    static func == (lhs: NDPump, rhs: NDPump) -> Bool {
        return lhs.rawData == rhs.rawData &&
            lhs.pumpName == rhs.pumpName &&
            lhs.activeRegimenFlow == rhs.activeRegimenFlow &&
            lhs.alarmCode == rhs.alarmCode &&
            lhs.batteryStatus == rhs.batteryStatus &&
            lhs.deliverDose == rhs.deliverDose &&
            lhs.maxDeliveredDose == rhs.maxDeliveredDose &&
            lhs.timeUntilEndOfTreatment == rhs.timeUntilEndOfTreatment &&
            lhs.unit == rhs.unit &&
            lhs.pumpStatus == rhs.pumpStatus &&
            lhs.timeUntilCartridgeReplacement == rhs.timeUntilCartridgeReplacement &&
            lhs.alarmDetailsCode == rhs.alarmDetailsCode &&
            lhs.timeSinceDurationStopped == rhs.timeSinceDurationStopped
    }

}