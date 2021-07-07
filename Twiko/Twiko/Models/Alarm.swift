////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// Alarm.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        1.7.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
final class Alarm {

    let alarmType: AlarmType

    /// Title of alert
    let title: String

    // Description of alert
    let description: String

    // alert information eg. when was it triggered
    let info: String

    // Alert image
    let icon: ImageAsset

    init(alarmType: AlarmType, title: String, description: String, info: String, icon: ImageAsset) {
        self.alarmType = alarmType
        self.title = title
        self.description = description
        self.info = info
        self.icon = icon
    }
}
