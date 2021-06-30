////////////////////////////////////////////////////////////////////////////////
//
// Digital Atrium Twiko
// Copyright (c) 2021 Digital Atrium
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by Digital Atrium.
//
// PumpAlarmStatusDataParser.swift
//
// AUTHOR IDENTITY:
//        Bojana Vojvodic        21.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
final class PumpDataParser {

    /**
     Parse pump alarm status data.
     - parameter advertisementData: Bytes array of data from the pump.
     - returns `PumpAlarmStatus`: Pump alarm status from the pump whitch include alarm code, alarm details code, is sound anbled and no treatmant duration in miliseconds.
     */
    static func parseAlarmData(advertisementData: Data) -> PumpAlarm? {

        // get UInt8 array from advertisement data
        var byteArray = [UInt8](advertisementData)
        byteArray.reverse()
        var pumpAlarmStatus: PumpAlarm?
        // if byte have 13 or more bytes
        if byteArray.count >= 12 {
            pumpAlarmStatus = PumpAlarm()

            // Parse alarm code
            pumpAlarmStatus?.alarmCode = byteArray[0]
            if let alarmCode = pumpAlarmStatus?.alarmCode, alarmCode > 30 {
                pumpAlarmStatus?.alarmDetailsCode = alarmCode - 30
                pumpAlarmStatus?.alarmCode = 1
            } else {
                pumpAlarmStatus?.alarmDetailsCode = byteArray[1]
            }

            pumpAlarmStatus?.isSoundEnabled = byteArray[8] != 0

            let data = Data([byteArray[9], byteArray[10], byteArray[11], byteArray[12]])
            let value = UInt32(littleEndian: data.withUnsafeBytes { $0.pointee }) * 1000
            pumpAlarmStatus?.noTreatmentDuration = value
        }
        return pumpAlarmStatus
    }

    /**
     Parse pump status register.
     - parameter advertisementData: Bytes array of data from the pump.
     - returns `NDPumpStatus`:  Pump alarm status register class.
     */
    static func parsePumpStatusRegister(advertisementData: Data) -> NDPumpStatus? {
        // get UInt8 array from advertisement data
        guard let firstByte = [UInt8](advertisementData).first else {
            return nil
        }
        let bits = firstByte.bits()
        var pumpStatus: NDPumpStatus?

        // if byte have more than 7 bytes
        if bits.count > 7 {
            pumpStatus = NDPumpStatus()
            pumpStatus?.isFtuDone = bits[0].boolValue
            pumpStatus?.cartridgeAttached = bits[1].boolValue
            pumpStatus?.coupledToStation = bits[2].boolValue
            pumpStatus?.deliveringMedicine = bits[3].boolValue
            pumpStatus?.inFillingState = bits[4].boolValue
            pumpStatus?.inFullTreatmentFlow = bits[5].boolValue
            pumpStatus?.isCartridgeRemovedInLastOneHour = bits[6].boolValue
            pumpStatus?.isAlarmAcknowledged = bits[7].boolValue
        }
        return pumpStatus
    }

    /**
     Parse pump clock synchronization.
     - parameter advertisementData: Bytes array of data from the pump.
     - returns `UInt64`:  Time in miliseconds from pump.
     */
    static func parsePumpClockSynchronizationData(advertisementData: Data) -> UInt64? {

        // get UInt8 array from advertisement data
        var byteArray = [UInt8](advertisementData)
        byteArray.reverse()

        var time: UInt64?

        // if byte have 8 or more bytes
        if byteArray.count >= 8 {
            let data = Data([byteArray[0], byteArray[1], byteArray[2], byteArray[3], byteArray[4], byteArray[5], byteArray[6], byteArray[7]])
            time = UInt64(littleEndian: data.withUnsafeBytes { $0.pointee })
            return time
        }
        return time
    }

    /**
     Parse pump decryption data key.
     - parameter advertisementData: Bytes array of data from the pump.
     - returns `String`:  String whitch represents decryption key.
     */
    static func parseDecryptionKeyData(advertisementData: Data) -> String? {

        // get UInt8 array from advertisement data
        let byteArray = [UInt8](advertisementData)
        return String(bytes: byteArray, encoding: .ascii)
    }
}
