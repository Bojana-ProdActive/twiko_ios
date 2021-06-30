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

    /**
     Tells the delegate the pump alarm status has been changed
     - parameter pump: Pump with updated alarm data.
     */
    func didPumpAlarmChanged(_ pump: Pump)

    /**
     Tells the delegate the pump status register has been changed
     - parameter pump: Pump with updated pump status register data.
     */
    func didPumpStatusRegisterChanged(_ pump: Pump)
}

public protocol BroadcastReadingDelegate: AnyObject {

    /**
     Tells the delegate the broadcast data are read.
     */
    func didReadBroadcastData(broadcastModel: BroadcastModel?)

}

public protocol PumpManagerInterface {
    /**
     The object that acts as the delegate of the PumpService
     */
    var delegate: PumpManagerDelegate? { get set }

    /**
     Configure Connection manager before usage. It should be called once.
     */
    func configure()

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
     Make connection with pump and exchange bounding keys.

     This method trigger pairing, pump select and write default authorization key.
     For every next connection use **reconnect(_ peripheral: Peripheral, key: Data)**
     - parameter peripheral: A peripheral object that retains a reference to the pump we want to connect to us.
     */
    func connectFirstTime(_ peripheral: Peripheral)

    /**
     Connect to the pump that exchanged the bounding key.

     Connect on paired pump.
     - parameter peripheral: A peripheral object that retains a reference to the pump we want to connect to us.
     - parameter key: Data object that represent authorization key.
     */
    func reconnect(_ peripheral: Peripheral, key: Data)

    /**
     Returns a list of known peripherals by their identifiers.
     - parameter identifier: A peripheral identifiers from which CBPeripheral objects can be retrieved.
     - returns: A list of peripherals that the central manager is able to match to the provided identifier.
     */
    func retrievePeripheral(withIdentifier identifier: String) -> [Peripheral]

    /**
     Disconnect from connected pump. For callback events listen PumpManagerDelegate.
     */
    func disconnect()

    /**
     Send command for watchdog test and start disconnection
     */
    func startWatchdogTest()

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

    /**
     Read alarm status from the connected pump.
     - parameter handler: The block to be executed when the pump read pump data.
     */
    func readAlarmStatus(handler: ((Result<Pump?, Error>) -> Void)?)

    /**
     Read pump status register from the connected pump.
     - parameter handler: The block to be executed when the pump read pump data.
     */
    func readStatusRegister(handler: ((Result<Pump?, Error>) -> Void)?)

    /**
     Read time (clock sync) from the connected pump.
     - parameter handler: The block to be executed when the pump read pump data.
     */
    func readPumpTime(handler: ((Result<Pump?, Error>) -> Void)?)

    /**
     Write time on the connected pump.
     - parameter handler: The block to be executed when pump wrute data.
     */
    func writePumpTime(milliseconds: UInt64, handler: ((Result<Bool, Error>) -> Void)?)

    /**
     Read broadcast decryption key.
     - parameter handler: The block to be executed when the pump read broadcast decryption key.
     */
    func readBroadcastDecryptionKey(handler: ((Result<String?, Error>) -> Void)?)

    /**
     Read minimum value (above 0) that can be set for segment medicine flow rate and returns Pump object with assigned value as callback parameter.
     - parameter handler: A block to execute when a read is performed.
     */
    func readRegimenSetupMinimumValue(handler: ((Result<Pump, Error>) -> Void)?)

    /**
     Read maximum value that can be set for segment medicine flow rate and returns Pump object with assigned value as callback parameter.
     - parameter handler: A block to execute when a read is performed.
     */
    func readRegimenSetupMaximumValue(handler: ((Result<Pump, Error>) -> Void)?)

    /**
     Read maximum daily dose value that can be set  and returns Pump object with assigned value as callback parameter.
     - parameter handler: A block to execute when a read is performed.
     */
    func readMaximumDailyDoseValue(handler: ((Result<Pump, Error>) -> Void)?)

    /**
     Read current active Regimen position. In case there no activate one value is `-1`
     - parameter handler: A block to execute when a read is performed.
     */
    func readActiveRegimenIndex(handler: ((Result<Pump, Error>) -> Void)?)

    /**
     Read constant number of defined amount of Regimens saved on the pump and update pump object with read value.
     - parameter handler: A block to execute when a read is performed.
     */
    func readRegimenSize(handler: ((Result<Pump, Error>) -> Void)?)

    /**
     Download regimens from the pump.
     - parameter handler: A block to execute when download is performed.
     */
    func downloadRegimens( _ handler: ((Result<[PumpRegimen], Error>) -> Void)?)
}

public final class PumpManager: PumpManagerInterface {

    // MARK: - Static data

    /**
     Timeout after disconnect command
     */
    private static let disconnectTimeOut: TimeInterval = 0.8

    // MARK: - Public properties

    /// Returns the shared object (singleton instance)
    public static let shared: PumpManager = PumpManager()

    private(set) var pump: Pump = Pump()

    public weak var delegate: PumpManagerDelegate?

    lazy var connectinManager: ConnectionManagerInterface = ConnectionManager(delegate: self)

    private lazy var regimenManager: RegimenManager = RegimenManager(regimenDownloader: RegimenDownloader(pumpManager: self))

    // MARK: - Private properties

    private var disconnectTimer: Timer?

    // MARK: - Broadcast data

    lazy var broadcastManager = NDBroadcastManager(delegate: self)

    var pumpName: String?

    var decryptionKey: String?

    // MARK: - Initialization
    /**
     Default init method with internal access.
     From access outside of library use **shared** instance
     */
    init() {

    }

    // MARK: - Public interface

    public func configure() {
        connectinManager.configure()
    }

    public func scanForConnectablePumps() {
        Log.i("")
        connectinManager.stopScanningForDevices()
        connectinManager.scannDevices(withCBUUIDs: [CBUUID(string: ServiceType.genericAttributeProfile.rawValue)])
    }

    public func stopSearchingPumps() {
        Log.i("")
        connectinManager.stopScanningForDevices()
    }

    public func connectFirstTime(_ peripheral: Peripheral) {
        Log.i("")
        connectinManager.connectFirstTime(peripheral, authorizationEnabled: false)
    }

    public func reconnect(_ peripheral: Peripheral, key: Data) {
        Log.i("")
        connectinManager.reconnect(peripheral, authorizationData: key, authorizationEnabled: false)
    }

    public func retrievePeripheral(withIdentifier identifier: String) -> [Peripheral] {
        Log.i("")
        return connectinManager.retrievePeripheral(withIdentifier: identifier)
    }

    public func disconnect() {
        Log.i("")
        connectinManager.clearCommandQueue()
        sendDisconnectCommand { _ in
            self.startDisconnectTimer()
        }
    }

    public func startWatchdogTest() {
        Log.i("")
        sendStartWatchdogTestCommand { [weak self] result in
            switch result {
            case .success:
                self?.connectinManager.disconnectThePump()
            case .failure(let error):
                Log.w("Error: \(error)")
            }
        }
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

    public func readAlarmStatus(handler: ((Result<Pump?, Error>) -> Void)?) {
        connectinManager.read(.pumpAlarm) { [weak self] result in
            switch result {
            case .success(let data):
                Log.d("Command read pump alarm status sent")

                guard let data = data else {
                    handler?(.success(nil))
                    return
                }
                let pumpAlarmData = PumpDataParser.parseAlarmData(advertisementData: data)

                self?.pump.alarm = pumpAlarmData
                handler?(.success(self?.pump))
            case .failure(let error):
                Log.w("command: pump alarm, error: \(error), code: \(error.code), domain: \(error.domain)")
                handler?(.failure(error))
            }
        }
    }

    public func readStatusRegister(handler: ((Result<Pump?, Error>) -> Void)?) {
        connectinManager.read(.pumpStatusRegister) { [weak self] result in
            switch result {
            case .success(let data):
                Log.d("Command read pump status register sent")

                guard let data = data else {
                    handler?(.success(nil))
                    return
                }
                let pumpStatusData = PumpDataParser.parsePumpStatusRegister(advertisementData: data)

                self?.pump.pumpStatus = pumpStatusData
                handler?(.success(self?.pump))
            case .failure(let error):
                Log.w("command: pump status register, error: \(error), code: \(error.code), domain: \(error.domain)")
                handler?(.failure(error))
            }
        }
    }

    public func readPumpTime(handler: ((Result<Pump?, Error>) -> Void)?) {
        connectinManager.read(.clockSynchronization) { [weak self] result in
            switch result {
            case .success(let data):
                Log.d("Command read pump time (clock sync) sent")
                guard let data = data else {
                    handler?(.success(nil))
                    return
                }

                let time = PumpDataParser.parsePumpClockSynchronizationData(advertisementData: data)
                self?.pump.pumpTime = time
                handler?(.success(self?.pump))
            case .failure(let error):
                Log.w("command: read clock synchronization, error: \(error), code: \(error.code), domain: \(error.domain)")
                handler?(.failure(error))
            }
        }
    }

    public func writePumpTime(milliseconds: UInt64, handler: ((Result<Bool, Error>) -> Void)?) {
        let newTime = milliseconds.getDataByteArray()
        connectinManager.write(newTime, characteristicType: .clockSynchronization, handler: { [weak self] result in
            switch result {
            case .success:
                Log.d("Command write time on the pump (clock sync) sent")

                self?.pump.pumpTime = milliseconds
                handler?(.success(true))
            case .failure(let error):
                Log.w("command: write clock synchronization, error: \(error), code: \(error.code), domain: \(error.domain)")
                handler?(.failure(error))
            }
        })
    }

    public func readBroadcastDecryptionKey(handler: ((Result<String?, Error>) -> Void)?) {
        connectinManager.read(.pumpBroadcastDecryptionKey) { [weak self] result in
            switch result {
            case .success(let decryptionKeyData):
                Log.d("Command read broadcast decryption key sent")
                guard let decryptionKeyData = decryptionKeyData else {
                    handler?(.success(nil))
                    return
                }
                let decryptionKeyString = PumpDataParser.parseDecryptionKeyData(advertisementData: decryptionKeyData)
                self?.decryptionKey = decryptionKeyString
                handler?(.success(self?.decryptionKey))
            case .failure(let error):
                Log.w("command: read broadcast decryption key, error: \(error), code: \(error.code), domain: \(error.domain)")
                handler?(.failure(error))
            }
        }
    }

    func readRawData(_ characteristicType: CharacteristicType, handler: ((_ result: Result<Data?, Error>) -> Void)?) {
        connectinManager.read(characteristicType, handler: handler)
    }

    func writeRawData(_ data: Data, characteristicType: CharacteristicType, handler: ((_ result: Result<Data?, Error>) -> Void)?) {
        connectinManager.write(data, characteristicType: characteristicType, handler: handler)
    }
}

// MARK: - Regimens

extension PumpManager {
    public func readRegimenSetupMinimumValue(handler: ((Result<Pump, Error>) -> Void)?) {
        connectinManager.read(.regimenSetupMinimumValue) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    let value = UInt64.create(fromBigEndian: data)
                    self.pump.setLimitationRegimenSetupMinValue(value)
                    Log.d(value)
                }
                handler?(.success(self.pump))
            case .failure(let error):
                Log.w(error)
                handler?(.failure(error))
            }
        }
    }

    public func readRegimenSetupMaximumValue(handler: ((Result<Pump, Error>) -> Void)?) {
        connectinManager.read(.regimenSetupMaximumValue) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    let value = UInt64.create(fromBigEndian: data)
                    self.pump.setLimitationRegimenSetupMaxValue(value)
                    Log.d(value)
                }
                handler?(.success(self.pump))
            case .failure(let error):
                Log.w(error)
                handler?(.failure(error))
            }
        }
    }

    public func readMaximumDailyDoseValue(handler: ((Result<Pump, Error>) -> Void)?) {
        connectinManager.read(.maximumDailyDoseValue) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    let value = UInt64.create(fromBigEndian: data)
                    self.pump.setLimitationRegimenDailyDoseMaxValue(value)
                    Log.d(value)
                }
                handler?(.success(self.pump))
            case .failure(let error):
                Log.w(error)
                handler?(.failure(error))
            }
        }
    }

    public func readActiveRegimenIndex(handler: ((Result<Pump, Error>) -> Void)?) {
        connectinManager.read(.activeRegimenIndex) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    Log.d(data.hexEncodedString())
                    self.pump.activeRegimenIndex = Int32.create(fromBigEndian: data)
                }
                handler?(.success(self.pump))
            case .failure(let error):
                Log.w(error)
                handler?(.failure(error))
            }
        }
    }

    public func readRegimenSize(handler: ((Result<Pump, Error>) -> Void)?) {
        connectinManager.read(.regimenSize) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    Log.d(data.hexEncodedString())
                    self.pump.activeRegimenIndex = Int32.create(fromBigEndian: data)
                }
                handler?(.success(self.pump))
            case .failure(let error):
                Log.w(error)
                handler?(.failure(error))
            }
        }
    }

    public func downloadRegimens(_ handler: ((Result<[PumpRegimen], Error>) -> Void)?) {
        regimenManager.download(handler)
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

    private func startDisconnectTimer() {
        Log.v("")
        stopDisconnectTimer()
        disconnectTimer = Timer.scheduledTimer(withTimeInterval: PumpManager.disconnectTimeOut, repeats: false, block: { [weak self] _ in
            Log.d("Disconnect timeout expired")
            // Remove reference on timer
            self?.stopDisconnectTimer()

            // Start disconnection
            self?.connectinManager.disconnectThePump()
        })
    }

    private func stopDisconnectTimer() {
        Log.v("")
        disconnectTimer?.invalidate()
        disconnectTimer = nil
    }

    /**
     Parse and update alarm data from the connected pump.
     - parameter data: Value of pump alarm characteristics.
     */
    private func updatePumpAlarmData(data: Data?) {
        guard let data = data else {
            return
        }

        let alarmData = PumpDataParser.parseAlarmData(advertisementData: data)
         pump.alarm = alarmData
    }

    /**
     Parse and update pump status register data from the connected pump.
     - parameter data: Value of pump status register characteristics.
     */
    private func updatePumpStatusRegisterData(data: Data?) {
        guard let data = data else {
            return
        }

        let pumpStatus = PumpDataParser.parsePumpStatusRegister(advertisementData: data)
        pump.pumpStatus = pumpStatus
    }

    /**
     Stop listening broadcast when pump is connected.
     */
    private func stopListeningBroadcast() {
        broadcastManager.stopScan()
    }

    /**
     Start listening broadcast when pump is not connected.
     */
    private func startListeningBroadcast() {
        guard let pumpName = pumpName else {
            Log.d("Pump name missing.")
            return
        }
        guard let decryptionKey = decryptionKey else {
            Log.d("Decryption key missing.")
            return
        }
        _ = broadcastManager.startScan(pumpName: pumpName, decryptionKey: decryptionKey)
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
        case .pumpAlarm:
            Log.v("Alarm status.")
            let alarmRowData = characteristic.value

            updatePumpAlarmData(data: alarmRowData)
            delegate?.didPumpAlarmChanged(pump)
        case .pumpStatusRegister:
            Log.v("Pump status register")

            updatePumpStatusRegisterData(data: characteristic.value)
            delegate?.didPumpStatusRegisterChanged(pump)
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
        pumpName = connectinManager.connectedPumpName
        stopListeningBroadcast()
        delegate?.didConnectPump()
    }

    func didDisconnectPeripheral(_ peripheral: CBPeripheral, error: Error?) {
        Log.w("device \(String(describing: peripheral.name)) disconnected, error: \(String(describing: error?.localizedDescription))")
        // Stop disconnect timer (disconnection occurred)
        stopDisconnectTimer()

        // Inform delegate
        delegate?.didDisconnectPump(error)
    }
}

// MARK: - Broadcast Delegate Interface

extension PumpManager: BroadcastReadingDelegate {

    public func didReadBroadcastData(broadcastModel: BroadcastModel?) {
        guard broadcastModel != nil else {
            Log.v("Failed to read broadcast data.")
            return
        }
        Log.v("Broadcast data are read successfully.")
    }

}
