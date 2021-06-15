////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// PumpVersion.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        7.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
struct PumpVersion: Codable {

    let communicationProtocolVersion: String?
    let firmwareVersion: String?
    let configurationFileVersion: String?
    let serialNumber: String?

    // MARK: - CodingKeys

    private enum CodingKeys: String, CodingKey {
        case communicationProtocolVersion = "comm"
        case firmwareVersion = "fw"
        case configurationFileVersion = "config"
        case serialNumber = "sn"
    }
}
