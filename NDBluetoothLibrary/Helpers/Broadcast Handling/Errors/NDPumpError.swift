////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// NDPumpError.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        11.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
enum NDPumpError: Error {

    case noPumpAvailable
    case alredyScanning

    public var localizedDescription: String {
        switch self {
        case .noPumpAvailable:
            return "No pump available."
        case .alredyScanning:
            return "Not scanning."
        }
    }
}
