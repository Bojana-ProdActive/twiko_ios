////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// Alerts.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        30.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
enum AlarmPriority: Int {
    case noAlert
    case high
    case medium
    case low
    case notDefined

    case warningNotification
    case maintanceNotification
}

enum AlarmType: UInt8, CaseIterable {

    // Codes taken from SCD document  SCD - Twiko system 17.06.2018.

    case noAlarm = 0

    // MARK: - High proprity alarms (stops delivery, Action required)

    case pumpMalfunction = 1                             // Pump technical failure
    case emptyBattery = 2                                // Battery level < CriticallyLowBatteryAlarm
    case emptyDrug = 3                                   // Drug level < EmptyDrugLevelAlarm
    case drugExpired = 4                                 // Duration since the last fill process completed > DrugExpiredAlarm
    case blockageDetected = 5                            // OcclusionAlarm was detected
    case cartridgeDisconnected = 6                   // Disconnected duration > EscalateToHighPriorityAlarm
    case treatmentPausedTooLong = 7                  // Pump in ready (pause) state duration >EscalateToHighPriorityAlarm
    /// 10 - 18 reserved for high priority alarms

    // MARK: - Medium priority alarms

    case treatmentPaused = 21                           // Immediately upon entering to ready (paused) state.

    // MARK: - Low priority alarms

    case pumpBatteryLow = 22                            // Battery < LowBatteryAlarm
    case drugDeliveryWillStopScan = 23                   // Less than TimePriorEndOfDelivery minutes left before EmptyDrugLevel OR Treatment Cycle Complete

    // MARK: - High priority notifications

    case fsMalfuncionNotification = 30                   // FS tecnical failure
    case fsFillProcessInterruptedNotification = 31        // FS detects pump uncopled during filling flow
    case fsFillProcessIncompleteNotification = 32         // FS detects unfinished Filling process -> NoUserInteraction

    case csCpuTemeratureCriticalNotification = 33
    case csBattTempertureHighNotification = 34
    case csCpuTemperatureHighNotification = 35

    case csWcTemperatureHeighNotification = 36
    case csBattFailNotification = 37
    case csBattLowNotification = 38
    case csWcErrorNotification = 39

    /**
     Get priority for alarm.
     - returns  `NDAlertPriority`: Possible values  `high`, `low`, `medium`, `notDefined`, or `noAlert`
     */
    func getAlertPriority() -> AlarmPriority {
        switch self {
        case .noAlarm:
            return AlarmPriority.noAlert
        case .pumpMalfunction,
             .emptyBattery,
             .emptyDrug,
             .drugExpired,
             .blockageDetected,
             .cartridgeDisconnected,
             .treatmentPausedTooLong:
            return AlarmPriority.high
        case .treatmentPaused:
            return AlarmPriority.medium
        case .pumpBatteryLow, .drugDeliveryWillStopScan:
            return AlarmPriority.low
        case .fsFillProcessIncompleteNotification:
            return AlarmPriority.warningNotification
        case .fsMalfuncionNotification,
             .fsFillProcessInterruptedNotification,
             .csCpuTemeratureCriticalNotification,
             .csBattTempertureHighNotification,
             .csCpuTemperatureHighNotification,
             .csWcTemperatureHeighNotification,
             .csBattFailNotification,
             .csBattLowNotification,
             .csWcErrorNotification:
            return AlarmPriority.maintanceNotification
        default:
            return AlarmPriority.notDefined
        }
    }

    /**
     Get event name for given alarm type.
     - parameter index: Predefined alarm type.
     - returns `NDAlert?`:  NDAlert for index if exist.
     */
    static func initFromIndex(index: UInt8) -> AlarmType? {
        return AlarmType(rawValue: index)
    }
}
