////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// UInt8.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        14.6.21.
//
////////////////////////////////////////////////////////////////////////////////
enum Bit: UInt8, CustomStringConvertible {
    case zero, one

    /// Get bit string description
    var description: String {
        switch self {
        case .one:
            return "1"
        case .zero:
            return "0"
        }
    }

    /// Get bit bool value
    var boolValue: Bool {
        switch self {
        case .one:
            return true
        case .zero:
            return false
        }
    }

}
import Foundation
////////////////////////////////////////////////////////////////////////////////
extension UInt8 {

    /// Get array of bits from UInt8
    func bits() -> [Bit] {
        var byte = self
        var bits = [Bit](repeating: .zero, count: 8)
        for i in 0..<8 {
            let currentBit = byte & 0x01
            if currentBit != 0 {
                bits[i] = .one
            }

            byte >>= 1
        }

        return bits
    }

}
