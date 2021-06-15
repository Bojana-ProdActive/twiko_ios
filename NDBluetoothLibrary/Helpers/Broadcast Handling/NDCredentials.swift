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
    var accessToken: String? { get set }
    var tokenType: String? { get set }
    var pushNotificationToken: String? { get set }
    var token: String { get set }

    func save()
    func reset()
    func removePumpData()
    func restoreCredentials()
    func isPumpPaired() -> Bool
}

final class NDCredentialsKeys {

    static let pumpNameKey = "kPumpName"
    static let descriptionKey = "kDecryptionKey"
    static let accessTokenKey = "kAccessToken"
    static let tokenTypeKey = "kTokenType"
    static let userKey = "kUserKey"
    static let pushNotificationTokenKey = "kPushNotificationToken"
    static let patientsKey = "kPatients"
    static let activePatientKey = "kActivePatientID"

}

final class NDCredentials: NDCredentialsProtocol {

    // MARK: - Static data

    private let keychain: Keychain = Keychain(service: Bundle.main.bundleIdentifier!)

   // MARK: - NDCredentialsProtocol Data

    var pumpName: String?
    var decryptionKey: String?
    var accessToken: String?
    var tokenType: String?
    var pushNotificationToken: String?
    var token: String {
        get {
            guard let accessToken = accessToken, let type = tokenType else {
                return ""
            }

            return type + accessToken
        }
        set {

        }
    }

    // MARK: - Initializers

    init() {
        restoreCredentials()
    }

    // MARK: - Heleprs

    func save() {
        if let pumpName = pumpName {
            keychain[NDCredentialsKeys.pumpNameKey] = pumpName
        }

        if let decryptionKey = decryptionKey {
            keychain[NDCredentialsKeys.descriptionKey] = decryptionKey
        }

        if let accessToken = accessToken {
            keychain[NDCredentialsKeys.accessTokenKey] = accessToken
        }

        if let tokenType = tokenType {
            keychain[NDCredentialsKeys.tokenTypeKey] = tokenType
        }

        if let pushNotificationToken = pushNotificationToken {
            keychain[NDCredentialsKeys.pushNotificationTokenKey] = pushNotificationToken
        }

    }

    func reset() {
        try? keychain.remove(NDCredentialsKeys.pumpNameKey)
        pumpName = nil

        try? keychain.remove(NDCredentialsKeys.descriptionKey)
        decryptionKey = nil

        try? keychain.remove(NDCredentialsKeys.accessTokenKey)
        accessToken = nil

        try? keychain.remove(NDCredentialsKeys.tokenTypeKey)
        tokenType = nil

    }

    func removePumpData() {
        try? keychain.remove(NDCredentialsKeys.pumpNameKey)
        pumpName = nil

        try? keychain.remove(NDCredentialsKeys.descriptionKey)
        decryptionKey = nil
    }

    func restoreCredentials() {
        if let pumpName = ((try? keychain.getString(NDCredentialsKeys.pumpNameKey)) as String??) {
            self.pumpName = pumpName
        }

        if let decryptionKey = ((try? keychain.getString(NDCredentialsKeys.descriptionKey)) as String??) {
            self.decryptionKey = decryptionKey
        }

        if let accessToken = ((try? keychain.getString(NDCredentialsKeys.accessTokenKey)) as String??) {
            self.accessToken = accessToken
        }

        if let tokenType = ((try? keychain.getString(NDCredentialsKeys.tokenTypeKey)) as String??) {
            self.tokenType = tokenType
        }

        if let pushNotificationToken = ((try? keychain.getString(NDCredentialsKeys.pushNotificationTokenKey)) as String??) {
            self.pushNotificationToken = pushNotificationToken
        }

    }

    func isPumpPaired() -> Bool {
        return decryptionKey != nil
    }
}
