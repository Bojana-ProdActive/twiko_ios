////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// KeychainManager.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        24.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import KeychainAccess
import NDBluetoothLibrary
////////////////////////////////////////////////////////////////////////////////
protocol KeychainProtocol {

    static var pumpVersion: String? { get set }
    static var pumpVerificationCode: String? { get set }
    static var pumpName: String? { get set }
    static var broadcastDescriptionKey: String? { get set }
    static var peripheralId: String? { get set }
    static var ftuDateTime: UInt64? { get set }
    static var filingCycleCount: Int? { get set }

}

final class KeychainManager: KeychainProtocol {

    // MARK: - Data

    private static let keychain: Keychain = Keychain(service: Bundle.main.bundleIdentifier!)

    // MARK: - Keychain protocol

    static var pumpVersion: String? {
        get {
            if let version = ((try? keychain.getString(KeychainKeys.pumpVersion)) as String?) {
                return version
            }
            return nil
        }
        set {
            keychain[KeychainKeys.pumpVersion] = newValue
        }
    }

    static var pumpVerificationCode: String? {
        get {
            if let code = ((try? keychain.getString(KeychainKeys.pumpVerificationCode)) as String?) {
                return code
            }
            return nil
        }
        set {
            keychain[KeychainKeys.pumpVerificationCode] = newValue
        }
    }

    static var pumpName: String? {
        get {
            if let name = ((try? keychain.getString(KeychainKeys.pumpName)) as String?) {
                return name
            }
            return nil
        }
        set {
            keychain[KeychainKeys.pumpName] = newValue
        }
    }

    static var broadcastDescriptionKey: String? {
        get {
            if let broadcastDescription = ((try? keychain.getString(KeychainKeys.broadcastDescription)) as String?) {
                return broadcastDescription
            }
            return nil
        }
        set {
            keychain[KeychainKeys.broadcastDescription] = newValue
        }
    }

    static var peripheralId: String? {
        get {
            if let id = ((try? keychain.getString(KeychainKeys.peripheralId)) as String?) {
                return id
            }
            return nil
        }
        set {
            keychain[KeychainKeys.peripheralId] = newValue
        }
    }

    static var ftuDateTime: UInt64? {
        get {
            if let date = ((try? keychain.getString(KeychainKeys.ftuDateTime)) as String?) {
                return UInt64(date)
            }
            return nil
        }
        set {
            guard let date = newValue else {
                return
            }
            let stringDate = String(date)
            keychain[KeychainKeys.ftuDateTime] = stringDate
        }
    }

    static var filingCycleCount: Int? {
        get {
            if let count = ((try? keychain.getString(KeychainKeys.filingCycleCount)) as String?) {
                return Int(count)
            }
            return nil
        }
        set {
            guard let count = newValue else {
                return
            }
            let stringCount = String(count)
            keychain[KeychainKeys.ftuDateTime] = stringCount
        }
    }
}
