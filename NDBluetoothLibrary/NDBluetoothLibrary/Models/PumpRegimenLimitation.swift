////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// PumpRegimenLimitation.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        23.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
public struct PumpRegimenLimitation: Codable {

    /// Regimen Setup Minimum Value. In **uL** (microlitre)
    internal(set) public var regimenSetupMin: UInt64 = 0

    /// Regimen Setup Maximum Value. In **uL** (microlitre)
    internal(set) public var regimenSetupMax: UInt64 = 0

    /// Maximum Daily Dose Value. In **uL** (microlitre)
    internal(set) public var dailyDoseMax: UInt64 = 0

    // MARK: - Coding keys

    private enum CodingKeys: String, CodingKey {
        case regimenSetupMin = "regimen_setup_min"
        case regimenSetupMax = "regimen_setup_max"
        case dailyDoseMax = "daily_dose_max"
    }
}
