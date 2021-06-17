////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// Data.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        17.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////
extension Data {
    /**
     Convert data to hex encoded string

     let data = Data(bytes: [0, 1, 127, 128, 255])
     data.hexEncodedString() / 00017f80ff
     */
    func hexEncodedString() -> String {
        let hexString = map { String(format: "%02hhx", $0) }.joined().uppercased()
        return "0x" + hexString
    }
}
