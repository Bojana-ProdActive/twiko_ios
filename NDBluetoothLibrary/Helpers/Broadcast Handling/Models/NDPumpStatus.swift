////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// NDPumpStatus.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        9.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
final class NDPumpStatus: Codable, Equatable {

    // swiftlint:disable discouraged_optional_boolean
    var isFtuDone: Bool?
    var cartridgeAttached: Bool?
    var coupledToStation: Bool?
    var deliveringMedicine: Bool?
    var inFillingState: Bool?
    var isCartridgeRemovedInLastOneHour: Bool?
    var isAlarmAcknowledged: Bool?

    // OLD fileds
    var batteryIsCharging: Bool?
    var inFullTreatmentFlow: Bool?
    var treatmentPaused: Bool?

    private enum CodingKeys: String, CodingKey {
        case isFtuDone = "is_ftu_done"
        case cartridgeAttached = "cartridge_attached"
        case coupledToStation = "coupled_to_station"
        case deliveringMedicine = "delivering_medicine"
        case isCartridgeRemovedInLastOneHour = "is_cartridge_removed_in_last_one_hour"
        case isAlarmAcknowledged = "is_alarm_acknowledged"

        case batteryIsCharging = "battery_charging"
        case inFillingState = "in_filling_state"
        case inFullTreatmentFlow = "in_full_treatment_flow"
        case treatmentPaused = "treatment_paused"
    }
    // swiftlint:enable discouraged_optional_boolean

    // MARK: - Coding keys

    static func == (lhs: NDPumpStatus, rhs: NDPumpStatus) -> Bool {
        return lhs.cartridgeAttached == rhs.cartridgeAttached &&
            lhs.isFtuDone == rhs.isFtuDone &&
            lhs.coupledToStation == rhs.coupledToStation &&
            lhs.deliveringMedicine == rhs.deliveringMedicine &&
            lhs.isCartridgeRemovedInLastOneHour == rhs.isCartridgeRemovedInLastOneHour &&
            lhs.isAlarmAcknowledged == rhs.isAlarmAcknowledged &&
            // OLD fields
            lhs.batteryIsCharging == rhs.batteryIsCharging &&
            lhs.inFillingState == rhs.inFillingState &&
            lhs.inFullTreatmentFlow == rhs.inFullTreatmentFlow &&
            lhs.treatmentPaused == rhs.treatmentPaused
    }
}
