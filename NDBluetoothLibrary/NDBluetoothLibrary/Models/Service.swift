////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// Service.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        31.5.21.
//
////////////////////////////////////////////////////////////////////////////////
import CoreBluetooth
import Foundation
////////////////////////////////////////////////////////////////////////////////
final class Service {
    let type: ServiceType
    let characteristics: [Characteristic]
    private(set) var cbService: CBService?

    init(type: ServiceType, characteristics: [Characteristic]) {
        self.type = type
        self.characteristics = characteristics
    }

    func setCbService(_ service: CBService) {
        cbService = service
    }
}
