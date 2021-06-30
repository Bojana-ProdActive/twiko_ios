////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// DecryptionManager.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        7.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
final class DecryptionManager {

    /// Decrypt data using AES128 algoritham, CTR mode, PKCS7 Padding
    ///
    /// - Parameter keyString: key used for decryption
    /// - Returns: decrypted data
    static func aes128Decrypt(data: Data, withKey keyString: String) -> Data? {
        // Key to Data
        let key: Data? = keyString.data(using: .utf8)

        // Init cryptor
        var cryptor: CCCryptorRef?

        // Empty IV: initialization vector
        let iv = Data(count: kCCBlockSizeAES128)

        // Create Cryptor
        let createDecrypt: CCCryptorStatus = CCCryptorCreateWithMode(CCOperation(kCCDecrypt),   // operation
            CCMode(kCCModeCTR),    // mode CTR
            CCAlgorithm(kCCAlgorithmAES128),   // Algorithm
            CCPadding(ccNoPadding), // padding
            (iv as NSData).bytes,  // can be NULL, because null is full of zeros
            (key! as NSData).bytes,    // key
            (key?.count)!, // keylength
            nil,   // const void *tweak
            0, // size_t tweakLength,
            0, // int numRounds,
            CCModeOptions(kCCModeOptionCTR_BE),    // CCModeOptions options,
            &cryptor)  // CCCryptorRef *cryptorRef

        if createDecrypt == kCCSuccess {
            // Alloc Data Out
            var cipherDataDecrypt = Data(count: data.count+kCCBlockSizeAES128)
            let cipherDataDecryptNS = NSMutableData(data: cipherDataDecrypt)

            // alloc number of bytes written to data Out
            var outLengthDecrypt: size_t = size_t()

            // Update Cryptor
            let updateDecrypt: CCCryptorStatus = CCCryptorUpdate(cryptor,
                                                                 (data as NSData).bytes,    // const void *dataIn,
                                                                 data.count, // size_t dataInLength,
                cipherDataDecryptNS.mutableBytes,  // void *dataOut,
                cipherDataDecryptNS.length,    // size_t dataOutAvailable,
                &outLengthDecrypt) // size_t *dataOutMoved)

            if updateDecrypt == kCCSuccess {
                // Cut Data Out with nedded length
                cipherDataDecryptNS.length = outLengthDecrypt

                // Final Cryptor
                let `final`: CCCryptorStatus = CCCryptorFinal(cryptor,  // CCCryptorRef cryptorRef,
                    cipherDataDecryptNS.mutableBytes, // void *dataOut,
                    cipherDataDecryptNS.length,   // size_t dataOutAvailable,
                    &outLengthDecrypt)    // size_t *dataOutMoved)

                if `final` == kCCSuccess {
                    // Release Cryptor
                    // CCCryptorStatus release =
                    CCCryptorRelease(cryptor)
                    // CCCryptorRef cryptorRef
                }

                cipherDataDecrypt = cipherDataDecryptNS as Data

                return cipherDataDecrypt
            }
        } else {
            // error
            print("Error accured while decrypting!")
        }
        return nil
    }

    /// Decrypt data using AES algoritham, ECB mode, no Padding
    ///
    /// - Parameter keyString: key used for decryption
    /// - Returns: decrypted data
    static func aesDecryptQR(data: Data, withKey keyString: String) -> Data? {
        // Key to Data
        let key: Data? = keyString.data(using: .utf8)

        // Init cryptor
        var cryptor: CCCryptorRef?

        // Empty IV: initialization vector
        let iv = Data(count: kCCBlockSizeAES128)

        // Create Cryptor
        let createDecrypt: CCCryptorStatus = CCCryptorCreateWithMode(CCOperation(kCCDecrypt),   // operation
            CCMode(kCCModeECB),    // mode ECB
            CCAlgorithm(kCCAlgorithmAES128),   // Algorithm
            CCPadding(ccNoPadding), // padding
            (iv as NSData).bytes,  // can be NULL, because null is full of zeros
            (key! as NSData).bytes,    // key
            (key?.count)!, // keylength
            nil,   // const void *tweak
            0, // size_t tweakLength,
            0, // int numRounds,
            CCModeOptions(kCCModeOptionCTR_BE),    // CCModeOptions options,
            &cryptor)  // CCCryptorRef *cryptorRef

        if createDecrypt == kCCSuccess {
            // Alloc Data Out
            var cipherDataDecrypt = Data(count: data.count+kCCBlockSizeAES128)
            let cipherDataDecryptNS = NSMutableData(data: cipherDataDecrypt)

            // alloc number of bytes written to data Out
            var outLengthDecrypt: size_t = size_t()

            // Update Cryptor
            let updateDecrypt: CCCryptorStatus = CCCryptorUpdate(cryptor,
                                                                 (data as NSData).bytes,    // const void *dataIn,
                                                                 data.count, // size_t dataInLength,
                cipherDataDecryptNS.mutableBytes,  // void *dataOut,
                cipherDataDecryptNS.length,    // size_t dataOutAvailable,
                &outLengthDecrypt) // size_t *dataOutMoved)

            if updateDecrypt == kCCSuccess {
                // Cut Data Out with nedded length
                cipherDataDecryptNS.length = outLengthDecrypt

                // Final Cryptor
                let `final`: CCCryptorStatus = CCCryptorFinal(cryptor,  // CCCryptorRef cryptorRef,
                    cipherDataDecryptNS.mutableBytes, // void *dataOut,
                    cipherDataDecryptNS.length,   // size_t dataOutAvailable,
                    &outLengthDecrypt)    // size_t *dataOutMoved)

                if `final` == kCCSuccess {
                    // Release Cryptor
                    // CCCryptorStatus release =
                    CCCryptorRelease(cryptor)
                    // CCCryptorRef cryptorRef
                }

                cipherDataDecrypt = cipherDataDecryptNS as Data

                return cipherDataDecrypt
            }
        } else {
            // error
            print("Error accured while decrypting!")
        }
        return nil
    }
}
