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

    func startScan(pumpName: String, decryptionKey: String) -> Error?
    func stopScan()

}

final class NDBroadcastManager: NSObject, NDBroadcastManagerProtocol {

    // MARK: - Static

    static let bluetoothTurnedOffNotificationName = Notification.Name(rawValue: "BluetoothTurnedOffNotificationName")
    private static let firstDataKey = "Generic Attribute Profile"
    private static let scanActiveTime: TimeInterval  = 10.0
    private static let scanInactiveTime: TimeInterval = 2.0

    // MARK: - Data

    private lazy var centralManager: CBCentralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    private var shouldStartNewScan: Bool = false
    private var isScanning: Bool = false
    private var peripheralFoundInTime: Bool = false
    private var timer: Timer?

    private weak var delegate: BroadcastReadingDelegate?

    // MARK: Initialization

    init(delegate: BroadcastReadingDelegate) {
        self.delegate = delegate
    }

    // MARK: - Pump data

    private var decryptionKey: String?
    private var pumpName: String?

    // MARK: - Interface

    var bluetoothManagerState: CBManagerState {
        return centralManager.state
    }

    func startScan(pumpName: String, decryptionKey: String) -> Error? {
        guard !isScanning else {
            debugPrint("[NDBroadcastManager] alredy scanning.")
            return NDPumpError.alredyScanning
        }

        self.decryptionKey = decryptionKey
        self.pumpName = pumpName

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
            Log.d("Not found peripheral")
        } else {
            Log.d("Found peripheral")
        }
        peripheralFoundInTime = false
        centralManager.scanForPeripherals(withServices: [CBUUID(string: ServiceType.genericAttributeProfile.rawValue)],
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
        guard let decryptionKey = decryptionKey else {
            return nil
        }

        let decryptedData = DecryptionManager.aes128Decrypt(data: data, withKey: decryptionKey)
        return decryptedData
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
           deviceName == pumpName,
           let dataDict = advertisementData[CBAdvertisementDataServiceDataKey] as? [AnyHashable: Any] {
            var data: Data = Data()
            for key in dataDict.keys where key.description == NDBroadcastManager.firstDataKey {
                data = dataDict[key] as! Data
            }
            peripheralFoundInTime = true

            if let decryptedData = decryptData(data: data) {
                var pumpData: BroadcastModel?
                if decryptedData.count == 13 {
                    pumpData = NDBroadcastDataParser.parseData(advertisementData: decryptedData)
                }
                pumpData?.pumpName = pumpName
                delegate?.didReadBroadcastData(broadcastModel: pumpData)
            } else {
                Log.d("Pump data can't be decrypted")
            }

        } else {
            Log.d("Advertizing data not available")
        }
    }
}
