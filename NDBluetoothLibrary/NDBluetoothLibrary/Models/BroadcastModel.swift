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
//        Bojana Vojvodic        9.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation

public final class BroadcastModel: Codable, Equatable {

    public var alarmCode: UInt8?
    public var alarmDetailsCode: UInt8 = 0
    public var timeUntilCartridgeReplacement: Int?
    public var batteryStatus: UInt8?
    public var activeRegimenFlow: Float?
    public var deliverDose: Float? // miliLiters
    public var maxDeliveredDose: Float?
    public var pumpName: String?
    public var pumpStatus: NDPumpStatus?
    public var timeUntilEndOfTreatment: Int?
    public var timeSinceDurationStopped: Int?

    var rawData: Data?

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
    }

    public static func == (lhs: BroadcastModel, rhs: BroadcastModel) -> Bool {
        return lhs.rawData == rhs.rawData &&
            lhs.pumpName == rhs.pumpName &&
            lhs.activeRegimenFlow == rhs.activeRegimenFlow &&
            lhs.alarmCode == rhs.alarmCode &&
            lhs.batteryStatus == rhs.batteryStatus &&
            lhs.deliverDose == rhs.deliverDose &&
            lhs.maxDeliveredDose == rhs.maxDeliveredDose &&
            lhs.timeUntilEndOfTreatment == rhs.timeUntilEndOfTreatment &&
            lhs.pumpStatus == rhs.pumpStatus &&
            lhs.timeUntilCartridgeReplacement == rhs.timeUntilCartridgeReplacement &&
            lhs.alarmDetailsCode == rhs.alarmDetailsCode &&
            lhs.timeSinceDurationStopped == rhs.timeSinceDurationStopped
    }

}
