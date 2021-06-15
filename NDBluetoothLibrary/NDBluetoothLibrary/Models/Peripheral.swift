////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// Peripheral.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        1.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import CoreBluetooth
////////////////////////////////////////////////////////////////////////////////
final public class Peripheral {
    public let localName: String
    let cbPeripheral: CBPeripheral

    init(name: String, peripheral: CBPeripheral) {
        localName = name
        cbPeripheral = peripheral
    }
}
