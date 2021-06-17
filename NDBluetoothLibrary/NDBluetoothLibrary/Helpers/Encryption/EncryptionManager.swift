////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// EncryptionManager.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        7.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation

////////////////////////////////////////////////////////////////////////////////
final class EncryptionManager {

    /// Encrypt data using AES128 algoritham, CTR mode, PKCS7 Padding
    ///
    /// - Parameter keyString: key used for encryption
    /// - Returns: encrypted data
    static func aes128Encrypt(data: Data, withKey keyString: String) -> Data? {

        //Key to Data
        let key: Data? = keyString.data(using: .utf8)

        // Init cryptor
        var cryptor: CCCryptorRef?

        // Alloc Data Out
        var cipherData = Data(count: data.count+kCCBlockSizeAES128)

        //Empty IV: initialization vector
        let iv = Data(count: kCCBlockSizeAES128)

        //Create Cryptor
        let create: CCCryptorStatus = CCCryptorCreateWithMode(CCOperation(kCCEncrypt),
                                                              CCMode(kCCModeCTR),
                                                              CCAlgorithm(kCCAlgorithmAES),
                                                              CCPadding(ccNoPadding),
                                                              (iv as NSData).bytes,         // can be NULL, because null is full of zeros
            (key! as NSData).bytes,
            (key?.count)!,
            nil,
            0,
            0,
            CCModeOptions(kCCModeOptionCTR_BE),
            &cryptor)

        if create == kCCSuccess {

            //alloc number of bytes written to data Out
            var outLength: size_t = size_t()

            //Update Cryptor
            let cipherDataNS = NSMutableData(data: cipherData)
            let update: CCCryptorStatus = CCCryptorUpdate(cryptor,
                                                          (data as NSData).bytes,
                                                          data.count,
                                                          cipherDataNS.mutableBytes,
                                                          cipherDataNS.length,
                                                          &outLength)

            if update == kCCSuccess {
                //Cut Data Out with nedded length
                cipherDataNS.length = outLength

                //Final Cryptor
                let `final`: CCCryptorStatus = CCCryptorFinal(cryptor,  //CCCryptorRef cryptorRef,
                    cipherDataNS.mutableBytes,  //void *dataOut,
                    cipherDataNS.length, // size_t dataOutAvailable,
                    &outLength)   // size_t *dataOutMoved)
                if `final` == kCCSuccess {
                    //Release Cryptor
                    //CCCryptorStatus release =
                    CCCryptorRelease(cryptor)   //CCCryptorRef cryptorRef
                }

                cipherData = cipherDataNS as Data

                return cipherData
            }
        } else {
            //error
            print("Error accured while encrypting!")
        }
        return nil
    }

}
