////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// PumpAlarmStatus.swift
//
// AUTHOR IDENTITY:
//        Bojana Vojvodic        21.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
public struct PumpAlarm: Codable {

    var alarmCode: UInt8?
    var alarmDetailsCode: UInt8?
    var isSoundEnabled: Bool = false
    var noTreatmentDuration: UInt32?
    var alarmDescription: String?

    // MARK: - Coding keys

    private enum CodingKeys: String, CodingKey {
        case alarmCode = "alarm_code"
        case alarmDetailsCode = "alarm_details_code"
        case isSoundEnabled = "is_sound_enabled"
        case noTreatmentDuration = "no_treatment_duration"
        case alarmDescription = "alarm_description"
    }
}
