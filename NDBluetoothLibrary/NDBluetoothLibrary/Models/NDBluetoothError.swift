////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// NDBluetoothError.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        14.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
public enum NDBluetoothError: Error {
    case pumpHasNotConnected
    case connectionHasNotAllowed
    case readDataIsNil
    case characteristicIsNotDiscovered
}
