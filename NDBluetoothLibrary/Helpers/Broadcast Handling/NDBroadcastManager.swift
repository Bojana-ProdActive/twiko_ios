////////////////////////////////////////////////////////////////////////////////
//
// Prod-Active Solutions NDBluetoothLibrary
// Copyright (c) 2021 Prod-Active Solutions
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// NDBroadcastManager.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        9.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import CoreBluetooth
////////////////////////////////////////////////////////////////////////////////
protocol NDBroadcastManagerProtocol {

    var bluetoothManagerState: CBManagerState { get }

    func startScan() -> Error?
    func stopScan()

}

final class NDBroadcastManager: NSObject, NDBroadcastManagerProtocol {

    // MARK: - Static

    static let bluetoothTurnedOffNotificationName = Notification.Name(rawValue: "BluetoothTurnedOffNotificationName")
    private static let firstDataKey = "Generic Attribute Profile"
    private static let ndMedicationDosingSensorUUID = "00001801-0000-1000-8000-00805f9b34fb"
    private static let scanActiveTime: TimeInterval  = 10.0
    private static let scanInactiveTime: TimeInterval = 2.0

    // MARK: - Data

    private lazy var centralManager: CBCentralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    private var shouldStartNewScan: Bool = false
    private var isScanning: Bool = false
    private var peripheralFoundInTime: Bool = false
    private var timer: Timer?

    private var credentials: NDCredentialsProtocol = NDCredentials()
    private var pumpManager: NDPumpManagerProtocol = NDPumpManager()

    // MARK: - Initializers

    init(credentials: NDCredentialsProtocol? = NDCredentials(), pumpManager: NDPumpManagerProtocol? = NDPumpManager()) {
        self.credentials = credentials ?? NDCredentials()
        self.pumpManager = pumpManager ?? NDPumpManager()
    }

    // MARK: - Interface

    var bluetoothManagerState: CBManagerState {
        return centralManager.state
    }

    func startScan() -> Error? {
        guard !isScanning else {
            debugPrint("[NDBroadcastManager] alredy scanning.")
            return NDPumpError.alredyScanning
        }

        credentials.restoreCredentials()

        guard credentials.pumpName != nil else {
            debugPrint("[NDBroadcastManager] no pump name.")
            return NDPumpError.noPumpAvailable
        }

        shouldStartNewScan = true
        if centralManager.state == .poweredOn {
            isScanning = true
            startScanPeriod()
            return nil
        }
        return nil
    }

    func stopScan() {
        shouldStartNewScan = false
        isScanning = false
        stopScanPeriod()
        invalidateTimer()
    }

    // MARK: - Timer

    @objc private func startScanPeriod() {
        if !peripheralFoundInTime {
            debugPrint("[NDBaseBLEService startScanPeriod] Not found peripheral")
            pumpManager.setIsPumpConnected(false)
        } else {
            pumpManager.setIsPumpConnected(true)
        }
        peripheralFoundInTime = false
        centralManager.scanForPeripherals(withServices: [CBUUID(string: NDBroadcastManager.ndMedicationDosingSensorUUID)],
                                          options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        startScanTimeoutTimer()
    }

    @objc private func stopScanPeriod() {
        centralManager.stopScan()
        if shouldStartNewScan {
            scheduleNewScan()
        }
    }

    // MARK: - Timers

    private func scheduleNewScan() {
        timer = Timer.scheduledTimer(timeInterval: NDBroadcastManager.scanInactiveTime, target: self, selector: #selector(startScanPeriod), userInfo: nil, repeats: false)
    }

    private func startScanTimeoutTimer() {
        timer = Timer.scheduledTimer(timeInterval: NDBroadcastManager.scanActiveTime, target: self, selector: #selector(stopScanPeriod), userInfo: nil, repeats: false)
    }

    private func invalidateTimer() {
        timer?.invalidate()
    }

    // MARK: - Private

    /// Analyze current core bluetooth manager state, print info and if state is 'poweredOn' start scan for peripherals
    ///
    /// - Parameter state: CBManager state
    private func analyzeManagerState(state: CBManagerState) {
        debugPrint("[NDBaseBLEService analyzeManagerState] state: \(state)")
        switch state {
        case .poweredOff:
            NotificationCenter.default.post(name: NDBroadcastManager.bluetoothTurnedOffNotificationName, object: nil)
        case .poweredOn:
            self.isScanning = true
            self.startScanPeriod()
        default:
            break
        }
    }

    /// Decrypt data from broadcast package
    /// - Parameter data: encrypted data
    /// - Returns: decrypted data
    private func decryptData(data: Data) -> Data? {
        guard let decryptionKey = credentials.decryptionKey else {
            return nil
        }

        let decryptedData = DecryptionManager.aes128Decrypt(data: data, withKey: decryptionKey)
        return decryptedData
    }

    /// Save new pump data
    /// - Parameter pumpData: new pump data received in broadcast
    private func updateSharedData(pumpData: NDPump) {
        guard let name = pumpData.pumpName else {
            return
        }

        pumpManager.setPumpDataForKey(pumpData: pumpData, key: name)
    }
}

// MARK: - CBCentralManagerDelegate
extension NDBroadcastManager: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        analyzeManagerState(state: central.state)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        debugPrint("[NDBaseBLEService didDiscover] new peripheral discovered")
        if let deviceName = advertisementData[CBAdvertisementDataLocalNameKey] as? String,
           deviceName == credentials.pumpName,
           let dataDict = advertisementData[CBAdvertisementDataServiceDataKey] as? [AnyHashable: Any] {
            var data: Data = Data()
            for key in dataDict.keys where key.description == NDBroadcastManager.firstDataKey {
                data = dataDict[key] as! Data
            }

            peripheralFoundInTime = true
            pumpManager.setIsPumpConnected(true)

            if let decryptedData = decryptData(data: data) {
                var pumpData: NDPump?
                if decryptedData.count == 13 {
                    pumpData = NDBroadcastDataParser.parseData(advertisementData: decryptedData)
                }
                if let pumpData = pumpData, let name = peripheral.name {
                    pumpData.pumpName = name
                    pumpData.rawData = data
                    updateSharedData(pumpData: pumpData)
                }
            } else {
                debugPrint("[NDBaseBLEService didDiscover] Pump data can't be decrypted")
            }

        } else {
            debugPrint("[NDBaseBLEService didDiscover] Advertizing data not available")
        }
    }
}
