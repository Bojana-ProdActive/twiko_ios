////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// Characteristic.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        31.5.21.
//
////////////////////////////////////////////////////////////////////////////////
import CoreBluetooth
import Foundation
////////////////////////////////////////////////////////////////////////////////
final class Characteristic {
    let type: CharacteristicType
    private(set) var cbCharacteristic: CBCharacteristic?
    // swiftlint:disable discouraged_optional_boolean
    private(set) var notify: Bool?
    // swiftlint:enable discouraged_optional_boolean

    init(type: CharacteristicType) {
        self.type = type
    }

    func setCbCharacteeristic(_ characteristic: CBCharacteristic) {
        cbCharacteristic = characteristic
    }

    func setNotify(_ notify: Bool) {
        self.notify = notify
    }

    var isDiscovered: Bool {
        return cbCharacteristic != nil
    }
}
