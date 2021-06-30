////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// NDBroadcastDataParser.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        14.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
final class NDBroadcastDataParser {

    /// Parse pump advertisement data using pump documentation
    ///
    /// - Parameter advertisementData: data from pump
    /// - Returns: NDPump object which contains all important data from pump
    static func parseData(advertisementData: Data) -> BroadcastModel? {
        // get UInt8 array from advertisement data
        let byteArray = [UInt8](advertisementData)
        var pumpData: BroadcastModel?
        // if byte have 13 or more bytes
        if byteArray.count >= 12 {
            pumpData = BroadcastModel()

            // Parse alarm code
            pumpData?.alarmCode = byteArray[0]
            if let alarmCode = pumpData?.alarmCode, alarmCode > 30 {
                pumpData?.alarmDetailsCode = alarmCode - 30
                pumpData?.alarmCode = 1
            }

            // pump status register
            pumpData?.pumpStatus = NDBroadcastDataParser.parsePumpStatusRegister(statusByte: byteArray[1])

            // battery status
            pumpData?.batteryStatus = byteArray[2]

            // active regimen idnex
            pumpData?.activeRegimenFlow = Float(byteArray[3]) * 0.01

            // delivered dose
            let decimalPartDeliveredDose: UInt8! = byteArray[4]
            let integerPartDeliveredDose: UInt8! = byteArray[5]
            pumpData?.deliverDose = Float(integerPartDeliveredDose) + Float(decimalPartDeliveredDose)/100 // value in mililiters

            // total daily dose
            let decimalPartTotalDailyDose: UInt8! = byteArray[6]
            let integerPartTotalDailyDose: UInt8! = byteArray[7]
            pumpData?.maxDeliveredDose = Float(integerPartTotalDailyDose) + Float(decimalPartTotalDailyDose)/100 // value in mililiters

            // Next treatment start time
            var hour = Int(byteArray[9])
            var minute = Int(byteArray[8])

            var value = Int(byteArray[9])
            if value < 0 {
                value = Int(hour * 100 - minute)
            } else {
                let sum = hour * 100 + minute
                value = Int(sum)
            }
            pumpData?.timeUntilEndOfTreatment = value

            // End of Treatment time
            if let isDeliverigMedicine = pumpData?.pumpStatus?.deliveringMedicine, let isFullTreatmantFlow = pumpData?.pumpStatus?.inFullTreatmentFlow, let alarmCode =  pumpData?.alarmCode, !isDeliverigMedicine, !isFullTreatmantFlow, alarmCode == 0 {
                pumpData?.timeUntilEndOfTreatment = 0
            }

            hour = Int(byteArray[11])
            minute = Int(byteArray[10])

            value = Int(byteArray[11])
            if value < 0 {
                value = Int(((byteArray[11]) << 8) | (byteArray[10]))
            } else {
                let sum = hour * 100 + minute
                value = Int(sum)
            }

            pumpData?.timeSinceDurationStopped = value
            pumpData?.timeUntilCartridgeReplacement = pumpData?.timeUntilEndOfTreatment
        }
        return pumpData
    }

    // MARK: - Helpers

    static func parsePumpStatusRegister(statusByte: UInt8) -> NDPumpStatus {
        let pumpStatusBits = statusByte.bits()
        var pumpStatus = NDPumpStatus()
        pumpStatus.isFtuDone = pumpStatusBits[0].boolValue
        pumpStatus.cartridgeAttached = pumpStatusBits[1].boolValue
        pumpStatus.coupledToStation = pumpStatusBits[2].boolValue
        pumpStatus.deliveringMedicine = pumpStatusBits[3].boolValue
        pumpStatus.inFillingState = pumpStatusBits[4].boolValue
        pumpStatus.inFullTreatmentFlow = pumpStatusBits[5].boolValue
        pumpStatus.isCartridgeRemovedInLastOneHour = pumpStatusBits[6].boolValue
        pumpStatus.isAlarmAcknowledged = pumpStatusBits[7].boolValue
        return pumpStatus
    }
}
