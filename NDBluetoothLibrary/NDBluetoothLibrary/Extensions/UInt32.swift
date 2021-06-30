////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// UInt32.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        23.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////
extension UInt32 {
    static func create(fromBigEndian data: Data) -> UInt32 {
        let value = data.withUnsafeBytes {
            $0.load(as: UInt32.self)
        }
        return UInt32(bigEndian: value)
    }
}
