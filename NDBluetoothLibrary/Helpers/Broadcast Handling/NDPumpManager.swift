////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// NDPumpManager.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        9.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import CoreBluetooth
import Foundation
////////////////////////////////////////////////////////////////////////////////
protocol NDPumpManagerProtocol {

    func setIsPumpConnected(_ isConnected: Bool)
    func setPumpDataForKey(pumpData: NDPump, key: String)
    func startListeningForData()
    func stopListeningForData()
    func getPumpDataForKey(key: String) -> NDPump?
    func getBluetootStatus() -> CBManagerState?
    func getIsPumpConnected() -> Bool
    func clearPumpDictionary()

}

final class NDPumpManager: NDPumpManagerProtocol {

    // MARK: - Data

    private var broadcastManager: NDBroadcastManagerProtocol = NDBroadcastManager()
    private let queue = DispatchQueue(label: "NDSharedPumpQueue", attributes: .concurrent)

    private var pumpDictionary: [String: NDPump]! {
        didSet {
//            NotificationCenter.default.post(Notification(name: NDNotificationName.foundPumpNotificationName))
        }
    }

    private var isPumpConnected = false {
        didSet {
//            NotificationCenter.default.post(Notification(name: NDNotificationName.changedBLEConnectionStatusNotificationName))
        }
    }

    init(broadcastManager: NDBroadcastManagerProtocol? = NDBroadcastManager()) {
        pumpDictionary = [String: NDPump]()
        self.broadcastManager = broadcastManager ?? NDBroadcastManager()
    }

    func startListeningForData() {
        broadcastManager.startScan()
    }

    func stopListeningForData() {
        broadcastManager.stopScan()
    }

    /// Thread safe method to set pumpDictionary item
    ///
    /// - Parameters:
    ///   - pumpData: pump data to add to dictionary
    ///   - key: pump name equals to key
    func setPumpDataForKey(pumpData: NDPump, key: String) {
        queue.async(flags: .barrier) {
            self.pumpDictionary[key] = pumpData
        }
    }

    /// Thread safe method to get pumpDictionary item
    ///
    /// - Parameter key: pump name equals to key
    /// - Returns: pump data for given key
    func getPumpDataForKey(key: String) -> NDPump? {
        var result: NDPump?
        queue.sync {
            result = self.pumpDictionary[key]
        }
        return result
    }

    /// Thread safe method to get pumpDictionary
    ///
    /// - Returns: pump dictionary
    func getPumpDictionary() -> [String: NDPump]? {
        var result: [String: NDPump]?
        queue.sync {
            result = self.pumpDictionary
        }
        return result
    }

    /// Get baseBLE service status
    ///
    /// - Returns: CBManagerState object
    func getBluetootStatus() -> CBManagerState? {
        return broadcastManager.bluetoothManagerState
    }

    /// Set pump connected status
    ///
    /// - Parameter isConnected: bool
    func setIsPumpConnected(_ isConnected: Bool) {
        queue.async(flags: .barrier) {
            self.isPumpConnected = isConnected
        }
    }

    /// Get pump connection status
    ///
    /// - Returns: pump connection status
    func getIsPumpConnected() -> Bool {
        var result: Bool!
        queue.sync {
            result = self.isPumpConnected
        }
        return result!
    }

    /// Clear pump dictionary
    func clearPumpDictionary() {
        queue.async(flags: .barrier) {
            self.pumpDictionary.removeAll()
        }
    }
}
