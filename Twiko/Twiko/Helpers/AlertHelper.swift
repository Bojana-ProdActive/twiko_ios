////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// AlertHelper.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        9.7.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////
final class AlertHelper {

    // swiftlint:disable cyclomatic_complexity
    static func alertTitle(_ alert: AlarmType) -> String {
        switch alert {
        case .noAlarm:
            return ""
        case .pumpMalfunction:
            return NSLocalizedString("Pump Malfunction", comment: "Pump Malfunction - alarm title")
        case .emptyBattery:
            return NSLocalizedString("Pump Battery Is Empty", comment: "Pump Battery Is Empty - alarm title")
        case .emptyDrug:
            return NSLocalizedString("Medication Is Empty", comment: "Medication Is Empty - alarm title")
        case .drugExpired:
            return NSLocalizedString("Treatment Cycle Ended", comment: "Treatment Cycle Ended - alarm title")
        case .blockageDetected:
            return NSLocalizedString("Blockage Detected", comment: "Blockage Detected - alarm title")
        case .cartridgeDisconnected:
            return NSLocalizedString("Cartridge Disconnected", comment: "Cartridge Disconnected - alarm title")
        case .treatmentPausedTooLong:
            return NSLocalizedString("Treatment Paused Too Long", comment: "Treatment Paused Too Long - alarm title")
        case .treatmentPaused:
            return NSLocalizedString("Treatment Paused", comment: "Treatment Paused - alarm title")
        case .pumpBatteryLow:
            return NSLocalizedString("Pump Battery Is Low", comment: "Pump Battery Is Low - alarm title")
        case .drugDeliveryWillStopScan:
            return NSLocalizedString("Medication Delivery Will Stop Soon", comment: "Medication Delivery Will Stop Soon - alarm title")
        case .fsMalfuncionNotification:
            return NSLocalizedString("Control Station malfunction", comment: "Control Station malfunction - alarm title")
        case .fsFillProcessInterruptedNotification:
            return NSLocalizedString("Process interrupted", comment: "Process interrupted - alarm title")
        case .fsFillProcessIncompleteNotification:
            return NSLocalizedString("Process incomplete", comment: "Process incomplete - alarm title")
        case .csCpuTemeratureCriticalNotification:
            return NSLocalizedString("Control Station temperature is critical", comment: "Control Station temperature is critical - alarm title")
        case .csBattTempertureHighNotification:
            return NSLocalizedString("Internal battery temperature is high", comment: "Internal battery temperature is high - alarm title")
        case .csCpuTemperatureHighNotification:
            return NSLocalizedString("Control Station temperature is high", comment: "Control Station temperature is high - alarm title")
        case .csWcTemperatureHeighNotification:
            return NSLocalizedString("Wireless Charger temperature is high", comment: "Wireless Charger temperature is high - alarm title")
        case .csBattFailNotification:
            return NSLocalizedString("Control Station battery faulty or not detected ", comment: "Control Station battery faulty or not detected - alarm title")
        case .csBattLowNotification:
            return NSLocalizedString("Control Station battery is low ", comment: "Control Station battery is low - alarm title")
        case .csWcErrorNotification:
            return NSLocalizedString("Pump Charging Error", comment: "Pump Charging Error - alarm title")
        }
    }
    // swiftlint:enable cyclomatic_complexity

    // swiftlint:disable cyclomatic_complexity
    static func alertDescription(_ alert: AlarmType) -> String {
        switch alert {
        case .noAlarm:
            return ""
        case .pumpMalfunction:
            return NSLocalizedString("Pump Medication is no longer being delivered. \nPlease contact Customer Care.", comment: "Pump Medication is no longer being delivered. \nPlease contact Customer Care. - alarm description")
        case .emptyBattery:
            return NSLocalizedString("Medication is no longer being delivered. \nInsert the pump into the Control Station to charge the battery.", comment: "Medication is no longer being delivered. \nInsert the pump into the Control Station to charge the battery. - alarm description")
        case .emptyDrug:
            return NSLocalizedString("Medication is no longer being delivered. \nTap the PREPARE TREATMENT button to start a new treatment.", comment: "Medication is no longer being delivered. \nTap the PREPARE TREATMENT button to start a new treatment. - alarm description")
        case .drugExpired:
            return NSLocalizedString("Medication is no longer being delivered. \nTap the PREPARE TREATMENT button to start a new treatment.", comment: "Medication is no longer being delivered. \nTap the PREPARE TREATMENT button to start a new treatment. - alarm description")
        case .blockageDetected:
            return NSLocalizedString("Medication is no longer being delivered. \nTap the PREPARE TREATMENT button to start a new treatment.", comment: "Medication is no longer being delivered. \nTap the PREPARE TREATMENT button to start a new treatment. - alarm description")
        case .cartridgeDisconnected:
            return NSLocalizedString("Medication is no longer being delivered. \nReconnect the cartridge to the pump to resume medication delivery.", comment: "Medication is no longer being delivered. \nReconnect the cartridge to the pump to resume medication delivery. - alarm description")
        case .treatmentPausedTooLong:
            return NSLocalizedString("Make sure the tubing lines are connected to the pump. Then press the PUMP button to resume treatment.", comment: "Make sure the tubing lines are connected to the pump. Then press the PUMP button to resume treatment. - alarm description")
        case .treatmentPaused:
            return NSLocalizedString("Make sure the tubing lines are connected to the pump. Then press the PUMP button to resume treatment.", comment: "Make sure the tubing lines are connected to the pump. Then press the PUMP button to resume treatment. - alarm description")
        case .pumpBatteryLow:
            return NSLocalizedString("Insert the pump into the Control Station to charge the pump.", comment: "Insert the pump into the Control Station to charge the pump. - alarm description")
        case .drugDeliveryWillStopScan:
            return NSLocalizedString("You will need to replace your cartridge. \nTap the PREPARE TREATMENT button to start a new treatment.", comment: "You will need to replace your cartridge. \nTap the PREPARE TREATMENT button to start a new treatment. - alarm description")
        case .fsMalfuncionNotification:
            return NSLocalizedString("Please call customer care to report the problem.", comment: "Please call customer care to report the problem. - alarm description")
        case .fsFillProcessInterruptedNotification:
            return NSLocalizedString("To resume filling, insert the pump into the Control Station. Make sure the cartridge is connected to the pump.", comment: "To resume filling, insert the pump into the Control Station. Make sure the cartridge is connected to the pump. - alarm description")
        case .fsFillProcessIncompleteNotification:
            return NSLocalizedString("Tap the RESUME PROCESS button to continue the flow. ", comment: "Tap the RESUME PROCESS button to continue the flow. - alarm description")
        case .csCpuTemeratureCriticalNotification:
            return NSLocalizedString("The device will shut down soon. \nPlease call customer care to report the problem.", comment: "The device will shut down soon. \nPlease call customer care to report the problem. - alarm description")
        case .csBattTempertureHighNotification:
            return NSLocalizedString("", comment: "")
        case .csCpuTemperatureHighNotification:
            return NSLocalizedString("The device might not work properly. \nPlease call customer care to report the problem.", comment: "The device might not work properly. \nPlease call customer care to report the problem. - alarm description")
        case .csWcTemperatureHeighNotification:
            return NSLocalizedString("Please be careful when touching the pump", comment: "Please be careful when touching the pump - alarm description")
        case .csBattFailNotification:
            return NSLocalizedString("Please call customer care to report the problem.", comment: "Please call customer care to report the problem. - alarm description")
        case .csBattLowNotification:
            return NSLocalizedString("Connect the Control Station to its power adapter before preparing the next day's treatment. If the problem persists, please call customer care.", comment: "Connect the Control Station to its power adapter before preparing the next day's treatment. If the problem persists, please call customer care. - alarm description")
        case .csWcErrorNotification:
            return NSLocalizedString("Make sure the pump is correctly inserted. \nIf the problem persists, please call customer care.", comment: "Make sure the pump is correctly inserted. \nIf the problem persists, please call customer care. - alarm description")
        }
    }
    // swiftlint:enable cyclomatic_complexity

    static func colorForAlert(_ alert: AlarmType) -> UIColor {
        let alertPriority = alert.getAlertPriority()
        switch alertPriority {
        case .high:
            return Asset.Colors.alertColorHigh.color
        case .medium:
            return Asset.Colors.alertColorMedium.color
        case .low:
            return Asset.Colors.alertColorLow.color
        case .maintanceNotification:
            return Asset.Colors.secondaryColor.color
        case .warningNotification:
            return Asset.Colors.primaryColor.color
        default:
            return .white
        }
    }

    static func titleColorOfAlert(_ alert: AlarmType) -> UIColor {
        switch alert.getAlertPriority() {
        case .high:
            return Asset.Colors.alertColorHigh.color
        default:
            return .black
        }
    }

    static func iconForAlert(_ alert: AlarmType) -> UIImage {
        switch alert.getAlertPriority() {
        case .high:
            return Asset.Images.Alarms.highPriorityAlarm.image
        case .medium:
            return Asset.Images.Alarms.mediumPriorityAlarm.image
        case .low:
            return Asset.Images.Alarms.lowPriorityAlarm.image
        case .maintanceNotification:
            return Asset.Images.maintanceNotification.image
        case .warningNotification:
            return Asset.Images.warningNotification.image
        default:
            return Asset.Images.Alarms.highPriorityAlarm.image
        }
    }
}
