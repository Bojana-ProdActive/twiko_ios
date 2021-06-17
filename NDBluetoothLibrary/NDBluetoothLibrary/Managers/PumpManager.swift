////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// PumpManager.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        27.5.21.
//
////////////////////////////////////////////////////////////////////////////////
import CoreBluetooth
import Foundation
////////////////////////////////////////////////////////////////////////////////
public protocol PumpManagerDelegate: AnyObject {
    func peripheralsListUpdated(_ peripherals: [Peripheral])

    /**
     Tells the delegate the device established connection with the pump.
     */
    func didConnectPump()

    /**
     Tells the delegate the device has not established connection with the pump.
     - parameter error: Error which describing reason why connection is not established
     */
    func didFailToConnect(_ error: Error?)

    /**
     Tells the delegate the pump disconnected from device
     - parameter error: Error which describing reason why disconnection occurred
     */
    func didDisconnectPump(_ error: Error?)
}

public protocol PumpManagerInterface {
    /**
     The object that acts as the delegate of the PumpService
     */
    var delegate: PumpManagerDelegate? { get set }

    /**
     Scan for pumps in range which availabel for connection.
     For result lissen *PumpManagerDelegate.peripheralsListUpdated(_ peripherals: [Peripheral])* method
     */
    func scanForConnectablePumps()

    /**
     Stop search for connectable pumps in the range
     */
    func stopSearchingPumps()

    /**
     Make connection with the pump.
     - warning: For connection status listen PumpManagerDelegate
     - parameter peripheral: Peripheral object which keeping reference on pump peripheral
     */
    func connect(_ peripheral: Peripheral)

    /**
     Send finish FTU commant to the connected pump.
     - parameter handler: The block to be executed when the pump acknowledges the received command.
     */
    func sendFinishFtuCommand(_ handler: ((Result<Bool, Error>) -> Void)?)

    /**
     Send turn off command to the connected pump.
     - parameter handler: The block to be executed when the pump acknowledges the received command.
     */
    func sendTurnOffCommand(_ handler: ((Result<Bool, Error>) -> Void)?)

    /**
     Send disconnect command to the connected pump.
     - parameter handler: The block to be executed when the pump acknowledges the received command.
     */
    func sendDisconnectCommand(_ handler: ((Result<Bool, Error>) -> Void)?)

    /**
     Send start regimen download command to the connected pump.
     - parameter handler: The block to be executed when the pump acknowledges the received command.
     */
    func sendStartRegimenDownloadCommand(_ handler: ((Result<Bool, Error>) -> Void)?)

    /**
     Send start regimen upload command to the connected pump.
     - parameter handler: The block to be executed when the pump acknowledges the received command.
     */
    func sendStartRegimenUploadCommand(_ handler: ((Result<Bool, Error>) -> Void)?)

    /**
     Send finish regimen upload command to the connected pump.
     - parameter handler: The block to be executed when the pump acknowledges the received command.
     */
    func sendFinishRegimenUploadCommand(_ handler: ((Result<Bool, Error>) -> Void)?)

    /**
     Send unpair command to the connected pump.
     - parameter handler: The block to be executed when the pump acknowledges the received command.
     */
    func sendUnpairCommand(_ handler: ((Result<Bool, Error>) -> Void)?)

    /**
     Send start filling medication command to the connected pump.
     - parameter handler: The block to be executed when the pump acknowledges the received command.
     */
    func sendStartFillingMedicationCommand(_ handler: ((Result<Bool, Error>) -> Void)?)

    /**
     Send start priming command to the connected pump.
     - parameter handler: The block to be executed when the pump acknowledges the received command.
     */
    func sendStartPrimingCommand(_ handler: ((Result<Bool, Error>) -> Void)?)

    /**
     Send start watchdog test command to the connected pump.
     - parameter handler: The block to be executed when the pump acknowledges the received command.
     */
    func sendStartWatchdogTestCommand(_ handler: ((Result<Bool, Error>) -> Void)?)

    /**
     Send clear pump logs command to the connected pump.
     - parameter handler: The block to be executed when the pump acknowledges the received command.
     */
    func sendClearPumpLogCommand(_ handler: ((Result<Bool, Error>) -> Void)?)

    /**
     Send switch to fill state command to the connected pump.
     - parameter handler: The block to be executed when the pump acknowledges the received command.
     */
    func sendSwitchToFillStateCommand(_ handler: ((Result<Bool, Error>) -> Void)?)

    /**
     Send stop logs download command to the connected pump.
     - parameter handler: The block to be executed when the pump acknowledges the received command.
     */
    func sendStopLogsDownloadCommand(_ handler: ((Result<Bool, Error>) -> Void)?)

    /**
     Send the pump to the boothloader command to the connected pump.
     - parameter handler: The block to be executed when the pump acknowledges the received command.
     */
    func sendThePumpToTheBoothloaderCommand(_ handler: ((Result<Bool, Error>) -> Void)?)

    /**
     Send acknowledge alarm command to the connected pump.
     - parameter handler: The block to be executed when the pump acknowledges the received command.
     */
    func sendAcknowledgeAlarmCommand(_ handler: ((Result<Bool, Error>) -> Void)?)

    /**
     Send keep alive command to the connected pump.
     - parameter handler: The block to be executed when the pump acknowledges the received command.
     */
    func sendKeepAliveCommand(_ handler: ((Result<Bool, Error>) -> Void)?)

    /**
     Send reset ftu and sent to ship mode command to the connected pump.
     - parameter handler: The block to be executed when the pump acknowledges the received command.
     */
    func sendResetFtuAndSendToShipModeCommand(_ handler: ((Result<Bool, Error>) -> Void)?)
}

public final class PumpManager: PumpManagerInterface {

    /// Returns the shared object (singleton instance)
    public static let shared: PumpManager = PumpManager()

    public weak var delegate: PumpManagerDelegate?

    lazy var connectinManager: ConnectionManagerInterface = ConnectionManager(delegate: self)

    /**
     Default init method vith internal access.
     From access outside of library use **shared** instance
     */
    init() {

    }

    public func scanForConnectablePumps() {
        Log.i("Scan started")
        connectinManager.stopScanningForDevices()
        connectinManager.scannDevices(withCBUUIDs: [CBUUID(string: ServiceType.genericAttributeProfile.rawValue)])
    }

    public func stopSearchingPumps() {
        Log.i("Scan stoped")
        connectinManager.stopScanningForDevices()
    }

    public func connect(_ peripheral: Peripheral) {
        Log.i("Connection started")
        connectinManager.connect(peripheral)
    }

    public func sendFinishFtuCommand(_ handler: ((Result<Bool, Error>) -> Void)?) {
        sendPumpCommand(command: .finishFtu, handler: handler)
    }

    public func sendTurnOffCommand(_ handler: ((Result<Bool, Error>) -> Void)?) {
        sendPumpCommand(command: .turnOffThePump, handler: handler)
    }

    public func sendDisconnectCommand(_ handler: ((Result<Bool, Error>) -> Void)?) {
        sendPumpCommand(command: .disconnect, handler: handler)
    }

    public func sendStartRegimenDownloadCommand(_ handler: ((Result<Bool, Error>) -> Void)?) {
        sendPumpCommand(command: .startRegimenDownload, handler: handler)
    }

    public func sendStartRegimenUploadCommand(_ handler: ((Result<Bool, Error>) -> Void)?) {
        sendPumpCommand(command: .startRegimenUpload, handler: handler)
    }

    public func sendFinishRegimenUploadCommand(_ handler: ((Result<Bool, Error>) -> Void)?) {
        sendPumpCommand(command: .finishRegimenUpload, handler: handler)
    }

    public func sendUnpairCommand(_ handler: ((Result<Bool, Error>) -> Void)?) {
        sendPumpCommand(command: .unpair, handler: handler)
    }

    public func sendStartFillingMedicationCommand(_ handler: ((Result<Bool, Error>) -> Void)?) {
        sendPumpCommand(command: .startFillingMedication, handler: handler)
    }

    public func sendStartPrimingCommand(_ handler: ((Result<Bool, Error>) -> Void)?) {
        sendPumpCommand(command: .startPriming, handler: handler)
    }

    public func sendStartWatchdogTestCommand(_ handler: ((Result<Bool, Error>) -> Void)?) {
        sendPumpCommand(command: .startWatchdogTest, handler: handler)
    }

    public func sendClearPumpLogCommand(_ handler: ((Result<Bool, Error>) -> Void)?) {
        sendPumpCommand(command: .clearPumpLog, handler: handler)
    }

    public func sendSwitchToFillStateCommand(_ handler: ((Result<Bool, Error>) -> Void)?) {
        sendPumpCommand(command: .switchToFillState, handler: handler)
    }

    public func sendStopLogsDownloadCommand(_ handler: ((Result<Bool, Error>) -> Void)?) {
        sendPumpCommand(command: .stopLogsDownload, handler: handler)
    }

    public func sendThePumpToTheBoothloaderCommand(_ handler: ((Result<Bool, Error>) -> Void)?) {
        sendPumpCommand(command: .sendThePumpToTheBootloader, handler: handler)
    }

    public func sendAcknowledgeAlarmCommand(_ handler: ((Result<Bool, Error>) -> Void)?) {
        sendPumpCommand(command: .acknowledgeAlarm, handler: handler)
    }

    public func sendKeepAliveCommand(_ handler: ((Result<Bool, Error>) -> Void)?) {
        sendPumpCommand(command: .keepAlive, handler: handler)
    }

    public func sendResetFtuAndSendToShipModeCommand(_ handler: ((Result<Bool, Error>) -> Void)?) {
        sendPumpCommand(command: .resetFtuAndSendToShipMode, handler: handler)
    }
}

// MARK: - Private methods

private extension PumpManager {

    /**
     Send command to the connected pump
     - parameter command: Pump command should be send to the connected device.
     - parameter handler: The block to be executed when the pump acknowledges the received command.
     */
    private func sendPumpCommand(command: PumpCommandType, handler: ((Result<Bool, Error>) -> Void)?) {
        let bytesArray: [UInt8] = [command.rawValue]
        connectinManager.write(Data(bytesArray), characteristicType: .pumpCommand) { result in
            switch result {
            case .success:
                Log.d("Command \(command) sent")
                handler?(.success(true))
            case .failure(let error):
                Log.w("command: \(command), error: \(error), code: \(error.code), domain: \(error.domain)")
                handler?(.failure(error))
            }
        }
    }
}

extension PumpManager: ConnectionManagerDelegate {
    func peripheralListUpdated(_ peripherals: [Peripheral]) {
        Log.i("")
        delegate?.peripheralsListUpdated(peripherals)
    }

    func pumpVersion(_ pumpVersion: PumpVersion) {
        // TODO: - Save data to keychain
        Log.d("Pump version: \(pumpVersion)")
    }

    func authorizaionKey(_ key: Data) {
        // TODO: - Save data to keychain
        Log.d("Auth data: \(key)")
    }

    func didUpdateValue(forCharacteristic characteristic: CBCharacteristic, error: Error?) {
        Log.v("notification arrived for characteristic \(characteristic.uuid.uuidString)")
        guard let type = CharacteristicType.characteristicType(withUuidString: characteristic.uuid.uuidString) else {
            Log.e("CharacteristicType with \(characteristic.uuid.uuidString) does not exist")
            return
        }

        switch type {
        case .startAuthentication:
            Log.v("Start authentication notification arrived")
        default:
            Log.v(type)
        }
    }

    func connectionFailed(error: Error?) {
        Log.e("Error: \(String(describing: error?.localizedDescription)), code: \(error?.code ?? -1), domain: \(String(describing: error?.domain))")
        delegate?.didFailToConnect(error)
    }

    func connectionSuccess() {
        Log.s("Pump connected")
        delegate?.didConnectPump()
    }

    func didDisconnectPeripheral(_ peripheral: CBPeripheral, error: Error?) {
        Log.w("device \(String(describing: peripheral.name)) disconnected, error: \(String(describing: error?.localizedDescription))")
        delegate?.didDisconnectPump(error)
    }
}
