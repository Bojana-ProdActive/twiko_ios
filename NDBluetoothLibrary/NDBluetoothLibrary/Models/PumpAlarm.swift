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

    public var alarmCode: UInt8?
    public var alarmDetailsCode: UInt8?
    public var isSoundEnabled: Bool = false
    public var noTreatmentDuration: UInt32?
    public var alarmDescription: String?

    init() {

    }

    public init(code: UInt8, detailsCode: UInt8?, isSoundEnabled: Bool, noTreatmentDuration: UInt32?, alarmDescription: String?) {
        self.alarmCode = code
        self.alarmDetailsCode = detailsCode
        self.isSoundEnabled = isSoundEnabled
        self.noTreatmentDuration = noTreatmentDuration
        self.alarmDescription = alarmDescription
    }

    // MARK: - Coding keys

    private enum CodingKeys: String, CodingKey {
        case alarmCode = "alarm_code"
        case alarmDetailsCode = "alarm_details_code"
        case isSoundEnabled = "is_sound_enabled"
        case noTreatmentDuration = "no_treatment_duration"
        case alarmDescription = "alarm_description"
    }
}
