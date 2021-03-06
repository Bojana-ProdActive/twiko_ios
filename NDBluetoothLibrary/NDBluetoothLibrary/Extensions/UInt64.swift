////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// UInt64.swift
//
// AUTHOR IDENTITY:
//        Bojana Vojvodic        23.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
extension UInt64 {
    static func create(fromBigEndian data: Data) -> UInt64 {
        let value = data.withUnsafeBytes {
            $0.load(as: UInt64.self)
        }
        return UInt64(bigEndian: value)
    }

    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt64>.size)
    }

    func getDataByteArray() -> Data {
        var tempArray = [UInt8](data)
        tempArray.reverse()
        return Data(tempArray)
    }
}
