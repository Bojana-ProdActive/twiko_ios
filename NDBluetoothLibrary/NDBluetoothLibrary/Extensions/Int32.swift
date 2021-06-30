////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// Int.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        23.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////
extension Int32 {
    static func create(fromBigEndian data: Data) -> Int32 {
        let value = data.withUnsafeBytes {
            $0.load(as: Int32.self)
        }
        return Int32(bigEndian: value)
    }
}
