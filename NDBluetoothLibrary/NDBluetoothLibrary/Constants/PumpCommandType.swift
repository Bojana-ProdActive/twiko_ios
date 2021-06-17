////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// PumpCommandType.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        16.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
public enum PumpCommandType: UInt8 {
    case finishFtu = 0x01
    case turnOffThePump = 0x02
    case disconnect = 0x03 // Disconnect from control station (current device: iPad, iPhone...)
    case startRegimenDownload = 0x04
    case startRegimenUpload = 0x05
    case finishRegimenUpload = 0x06
    case unpair = 0x09 // Unpair from control station (current device: iPad, iPhone ...)
    case startFillingMedication = 0x0A
    case startPriming = 0x0B
    case startWatchdogTest = 0x0C
    case clearPumpLog = 0x0D
    case switchToFillState = 0x0E // CSPreparationPhase
    case stopLogsDownload = 0x0F
    case sendThePumpToTheBootloader = 0x10
    case acknowledgeAlarm = 0x11
    case keepAlive = 0x12 // KeepCoupling
    case resetFtuAndSendToShipMode = 0x13
    case errorCallbacks = 0xFF
}
