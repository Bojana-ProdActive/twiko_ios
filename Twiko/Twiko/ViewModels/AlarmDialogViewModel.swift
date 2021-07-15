////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// AlarmDialogViewModel.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        13.7.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
import NDBluetoothLibrary
////////////////////////////////////////////////////////////////////////////////
enum AlarmDialogAction {
    case ok
    case prepareTreatment
    case audio
    case close
    case resumeProces
}

protocol AlarmDialogViewModelProtocol {

    func getActionsForAlarmDialog( _ alarm: AlarmType, _ connectionType: ConnectionType) -> [AlarmDialogAction]

}
final class AlarmDialogViewModel: AlarmDialogViewModelProtocol {

    func getActionsForAlarmDialog(_ alarm: AlarmType, _ connectionType: ConnectionType) -> [AlarmDialogAction] {
        var actions: [AlarmDialogAction] = []
        switch alarm {
        case .pumpMalfunction, .emptyBattery, .cartridgeDisconnected, .treatmentPausedTooLong, .treatmentPaused, .pumpBatteryLow:
            actions = connectionType == .broadcast ? [.ok] : [.audio]
        case .emptyDrug, .drugExpired, .blockageDetected, .drugDeliveryWillStopScan:
            actions = connectionType == .broadcast ? [.close, .prepareTreatment] : [.audio, .prepareTreatment]
        case .csBattTempertureHighNotification, .csWcTemperatureHeighNotification, .csCpuTemperatureHighNotification, .csBattFailNotification, .csBattLowNotification, .csWcErrorNotification:
            actions = [.ok]
        case .fsFillProcessIncompleteNotification:
            actions = [.resumeProces]
        case .fsFillProcessInterruptedNotification, .csCpuTemeratureCriticalNotification, .fsMalfuncionNotification:
            actions = []
        default:
            actions = []
        }
        return actions
    }
}
