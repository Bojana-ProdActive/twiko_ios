////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// AlarmManager.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        1.7.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
import NDBluetoothLibrary
////////////////////////////////////////////////////////////////////////////////
protocol AlarmManagerInterface {

    var maskedAlarmTypes: Set<AlarmType> { get }

    var unmaskableAlarmTypes: Set<AlarmType> { get }

    /**
     Pump alarm raised
     - parameter pumpAlarm: PumpAlarm object wich keeping data from raised alarm.
     */
    func pumpAlarmRaised(_ pumpAlarm: PumpAlarm)

    /**
     Mask all alarm types except passed as paramether
     - parameter alarmTypes: Array with alarm types that will be excluded from masking.
     */
    func maskAllExcept( _ alarmTypes: Set<AlarmType>)

    /**
     Mask alarm types passed as paramether
     */
    func mask( _ alarmTypes: Set<AlarmType>)
}

protocol AlarmManagerDelegate: AnyObject {
    func newAlarmAvailable( _ alarm: PumpAlarm, fromBroadcast: Bool)
    func alarmDataChanged(_ alarm: PumpAlarm, fromBroadcast: Bool)
    func allAlarmsSolved()
}

final class AlarmManager: AlarmManagerInterface {

    private var mutedBroadcastAlarmType: AlarmType?
    private(set) public var maskedAlarmTypes: Set<AlarmType> = []
    private weak var delegate: AlarmManagerDelegate?
    lazy var alarmPlayer: AlarmPlayerInterface = AlarmPlayer()

    fileprivate var alarmInfo: AlarmInfo?

    init(delegate: AlarmManagerDelegate?) {
        self.delegate = delegate
    }

    func pumpAlarmRaised(_ pumpAlarm: PumpAlarm) {
        // Reset broadcast data. New allarm occured in connected mode
        mutedBroadcastAlarmType = nil

        // Is alarm code valid
        guard let alarmCode = pumpAlarm.alarmCode,
              let alarmType = AlarmType(rawValue: alarmCode) else {
            return
        }

        // Is `noAlarm`
        guard alarmType != .noAlarm else {
            alarmInfo = nil
            delegate?.allAlarmsSolved()
            return
        }

        // Is masked alarm?
        guard !maskedAlarmTypes.contains(alarmType) else {
            // Save alarm data for future
            alarmInfo = AlarmInfo(alarmType: alarmType, alarm: pumpAlarm, fromBroadcast: false)
            return
        }

        // Play sound if `isSoundEnabled==true`
        if pumpAlarm.isSoundEnabled {
            playSound(forAlarmType: alarmType)
        }

        // Is same as last
        if let alarmData = alarmInfo,
           alarmData.alarmType == alarmType,
           !pumpAlarm.isSoundEnabled {
            alarmInfo = AlarmInfo(alarmType: alarmType, alarm: pumpAlarm, fromBroadcast: false)
            delegate?.alarmDataChanged(pumpAlarm, fromBroadcast: false)
            return
        }

        // New alarm occured
        alarmInfo = AlarmInfo(alarmType: alarmType, alarm: pumpAlarm, fromBroadcast: false)
        delegate?.newAlarmAvailable(pumpAlarm, fromBroadcast: false)
    }

    func broadcastPumpAlarmOccured(_ broadcastData: BroadcastModel) {

        // Is alarm code valid
        guard let alarmCode = broadcastData.alarmCode, let type = AlarmType(rawValue: alarmCode) else {
            return
        }

        // Is alarm masked
        guard !maskedAlarmTypes.contains(type) else {
            // Save for future usage
            mutedBroadcastAlarmType = nil
            alarmInfo = broadcastDataToAlarmInfo(type, broadcastData: broadcastData, isSoundEnabled: true)
            return
        }

        // Is noAlarm type
        guard type != .noAlarm else {
            mutedBroadcastAlarmType = nil
            alarmInfo = nil
            delegate?.allAlarmsSolved()
            return
        }

        // Is alarm muted
        guard type != mutedBroadcastAlarmType else {
            alarmInfo = broadcastDataToAlarmInfo(type, broadcastData: broadcastData, isSoundEnabled: false)
            return
        }

        // New alarm available
        mutedBroadcastAlarmType = type
        alarmInfo = broadcastDataToAlarmInfo(type, broadcastData: broadcastData, isSoundEnabled: true)
        delegate?.newAlarmAvailable(alarmInfo!.alarm, fromBroadcast: true)
    }

    func maskAllExcept( _ alarmTypes: Set<AlarmType>) {
        var container: Set<AlarmType> = Set(AlarmType.allCases)
        // Remove from imput
        for item in alarmTypes {
            container.remove(item)
        }

        // Remove unmascable
        for item in unmaskableAlarmTypes {
            container.remove(item)
        }
        maskedAlarmTypes = container
    }

    func mask( _ alarmTypes: Set<AlarmType>) {
        var container: Set<AlarmType> = []
        for alarmType in alarmTypes where !unmaskableAlarmTypes.contains(alarmType) {
            container.insert(alarmType)
        }

        maskedAlarmTypes = container
    }

    var unmaskableAlarmTypes: Set<AlarmType> {
        return [
            .noAlarm,
            .pumpMalfunction
        ]
    }

    private func broadcastDataToAlarmInfo(_ type: AlarmType, broadcastData: BroadcastModel, isSoundEnabled: Bool) -> AlarmInfo {
        let data = PumpAlarm(code: type.rawValue,
                             detailsCode: broadcastData.alarmDetailsCode,
                             isSoundEnabled: false,
                             noTreatmentDuration: nil,
                             alarmDescription: nil)
        return AlarmInfo(alarmType: type, alarm: data, fromBroadcast: true)
    }

    private func playSound(forAlarmType alarmType: AlarmType) {
        switch alarmType.getAlertPriority() {
        case .low:
            alarmPlayer.playLowPriorityAlert()
        case .medium:
            alarmPlayer.playMediumPriorityAlert()
        case .high:
            alarmPlayer.playHighPriorityAlert()
        case .noAlert:
            break
        case .notDefined:
            break
        }
    }
}

struct AlarmInfo {
    let alarmType: AlarmType
    let alarm: PumpAlarm
    let fromBroadcast: Bool
}
