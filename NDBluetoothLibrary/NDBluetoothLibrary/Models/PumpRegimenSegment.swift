////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// PumpRegimenSegment.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        23.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
public struct PumpRegimenSegment: Codable {
    public var startTime: UInt64 = 0
    public var value: UInt64 = 0

    // MARK: - CodingKeys

    private enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case value
    }
}

extension PumpRegimenSegment: Equatable {
    public static func == (lhs: PumpRegimenSegment, rhs: PumpRegimenSegment) -> Bool {
        return lhs.startTime == rhs.startTime &&
            lhs.value == rhs.value
    }
}
