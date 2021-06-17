////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// NDCredentials.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        9.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import KeychainAccess
////////////////////////////////////////////////////////////////////////////////
protocol NDCredentialsProtocol {

    var pumpName: String? { get set }
    var decryptionKey: String? { get set }

    func save()
    func reset()
    func removePumpData()
    func restoreCredentials()
    func isPumpPaired() -> Bool
}
final class NDCredentialsManager: NDCredentialsProtocol {

    // MARK: - Static data

    static let pumpNameKey = "kPumpName"
    static let descriptionKey = "kDecryptionKey"
    private let keychain: Keychain = Keychain(service: Bundle.main.bundleIdentifier!)

   // MARK: - NDCredentialsProtocol Data

    var pumpName: String?
    var decryptionKey: String?

    // MARK: - Initializers

    init() {
        restoreCredentials()
    }

    // MARK: - Heleprs

    func save() {
        if let pumpName = pumpName {
            keychain[NDCredentialsManager.pumpNameKey] = pumpName
        }

        if let decryptionKey = decryptionKey {
            keychain[NDCredentialsManager.descriptionKey] = decryptionKey
        }

    }

    func reset() {
        try? keychain.remove(NDCredentialsManager.pumpNameKey)
        pumpName = nil

        try? keychain.remove(NDCredentialsManager.descriptionKey)
        decryptionKey = nil

    }

    func removePumpData() {
        try? keychain.remove(NDCredentialsManager.pumpNameKey)
        pumpName = nil

        try? keychain.remove(NDCredentialsManager.descriptionKey)
        decryptionKey = nil
    }

    func restoreCredentials() {
        if let pumpName = ((try? keychain.getString(NDCredentialsManager.pumpNameKey)) as String??) {
            self.pumpName = pumpName
        }

        if let decryptionKey = ((try? keychain.getString(NDCredentialsManager.descriptionKey)) as String??) {
            self.decryptionKey = decryptionKey
        }
    }

    func isPumpPaired() -> Bool {
        return decryptionKey != nil
    }
}
