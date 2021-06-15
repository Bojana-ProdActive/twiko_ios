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
     Tells the delegate the device established connection with the pump.
     - parameter error: Error which describing reason why connection is not established
     */
    func didConnectionFailed(_ error: Error?)
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
}

public final class PumpManager: PumpManagerInterface {

    public static let shared: PumpManager = PumpManager()
    public weak var delegate: PumpManagerDelegate?

    lazy var connectinManager: ConnectionManagerInterface = ConnectionManager(delegate: self)

    init() {

    }

    public func scanForConnectablePumps() {
        Log.i("Scan started")
        connectinManager.stopScanningForDevices()
        connectinManager.scannDevices(withCBUUIDs: [CBUUID(string: "00001801-0000-1000-8000-00805F9B34FB")])
    }

    public func stopSearchingPumps() {
        Log.i("Scan stoped")
        connectinManager.stopScanningForDevices()
    }

    /// Attempt connect to periferal
    /// - Parameter peripheral: Periferal object
    public func connect(_ peripheral: Peripheral) {
        Log.i("Connection started")
        connectinManager.connect(peripheral)
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
            Log.v("Notification is not important")
        }
    }

    func didDisconnectPeripheral(_ peripheral: Peripheral, error: Error?) {
        Log.w("device \(peripheral.localName) disconnected, error: \(String(describing: error?.localizedDescription))")
    }

    func connectionFailed(error: Error?) {
        Log.e("Error: \(String(describing: error?.localizedDescription)), code: \(error?.code ?? -1), domain: \(String(describing: error?.domain))")
        delegate?.didConnectionFailed(error)
    }

    func connectionSuccess() {
        Log.s("Pump connected")
        delegate?.didConnectPump()
    }

    func didDisconnectPeripheral(_ peripheral: CBPeripheral, error: Error?) {
        Log.s("Pump disconnected")
    }
}
