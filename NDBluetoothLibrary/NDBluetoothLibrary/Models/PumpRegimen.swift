////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// PumpRegimen.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        23.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
public struct PumpRegimen: Codable {

    var segments: [PumpRegimenSegment] = []

    // MARK: - CodingKeys

    private enum CodingKeys: String, CodingKey {
        case segments
    }
}

extension PumpRegimen: Equatable {
    public static func == (lhs: PumpRegimen, rhs: PumpRegimen) -> Bool {
        return lhs.segments == rhs.segments
    }
}

// MARK: - Helpers

public extension PumpRegimen {

    /// Get sum of segments value
    func getTotalDailyDose() -> UInt64 {
        return segments.map { $0.value }
            .reduce(0, +)
    }
}
