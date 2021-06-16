////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// ServiceType.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        31.5.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
enum ServiceType: String, CaseIterable {
    case pump = "89FBD000-476A-4E5B-9FCF-58BE6B43C623"
    case regimen = "263F7000-5CFC-4DB5-927B-2F670FDCBCBB"
    case log = "59715000-A757-4879-9E1E-B843F85E672F"
    case general = "AFD04000-C496-4D71-96C6-25136C7D7339"
    case genericAttributeProfile = "00001801-0000-1000-8000-00805f9b34fb"
}
