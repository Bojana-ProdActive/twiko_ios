////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// Pump.swift
//
// AUTHOR IDENTITY:
//        Bojana Vojvodic        22.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
public struct Pump: Codable {

    var alarm: PumpAlarm?
    var pumpStatus: NDPumpStatus?
    var pumpTime: UInt64?
    var pumpRegimenLimitation: PumpRegimenLimitation = PumpRegimenLimitation()
    var activeRegimenIndex: Int32 = -1

    // MARK: - Coding keys

    private enum CodingKeys: String, CodingKey {
        case alarm = "pump_alarm"
        case pumpStatus = "pump_status"
        case pumpTime = "pump_time"
        case pumpRegimenLimitation = "pump_regimen_limitation"
    }

    mutating func setLimitationRegimenSetupMaxValue(_ value: UInt64) {
        pumpRegimenLimitation.regimenSetupMax = value
    }

    mutating func setLimitationRegimenSetupMinValue(_ value: UInt64) {
        pumpRegimenLimitation.regimenSetupMin = value
    }

    mutating func setLimitationRegimenDailyDoseMaxValue(_ value: UInt64) {
        pumpRegimenLimitation.dailyDoseMax = value
    }
}
