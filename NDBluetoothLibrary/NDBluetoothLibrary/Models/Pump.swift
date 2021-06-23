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

    // MARK: - Coding keys

    private enum CodingKeys: String, CodingKey {
        case alarm = "pump_alarm"
        case pumpStatus = "pump_status"
    }
}
