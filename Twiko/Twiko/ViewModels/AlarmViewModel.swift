////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// AlarmViewModel.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        12.7.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
import NDBluetoothLibrary
////////////////////////////////////////////////////////////////////////////////
enum AlarmAction {
    case pumpStatus
    case prepareTreatment
    case videoTutorials
}

enum ConnectionType {
    case broadcast
    case connected
}

protocol AlarmViewModelProtocol {
    func getAlarmActions(_ alarm: AlarmType) -> [AlarmAction]
}

final class AlarmViewModel: AlarmViewModelProtocol {

    func getAlarmActions(_ alarm: AlarmType) -> [AlarmAction] {
        var actions: [AlarmAction] = []
        switch alarm {
        case .pumpMalfunction:
            actions = []
        case .emptyBattery, .cartridgeDisconnected, .pumpBatteryLow:
            actions = [.pumpStatus]
        case .emptyDrug, .drugExpired, .blockageDetected, .drugDeliveryWillStopScan:
            actions = [.prepareTreatment, .pumpStatus]
        case .treatmentPausedTooLong, .treatmentPaused:
            actions = [.videoTutorials, .pumpStatus]
        default:
            actions = []
        }
        return actions
    }
}
