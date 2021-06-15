////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// Error.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        2.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////
extension Error {
    var code: Int {
        return (self as NSError).code
    }

    var domain: String {
        return (self as NSError).domain
    }
}
