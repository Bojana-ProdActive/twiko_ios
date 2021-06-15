//
//  EncryptionManagerTest.swift
//  NDBluetoothLibraryTests
//
//  Created by Digital Atrium on 7.6.21..
//
@testable import NDBluetoothLibrary
import XCTest

class EncryptionManagerTest: XCTestCase {

    private let decryptionKey = "6YusQqtbwPMT3Kt6"
    private let decryptionKeyShort = "6Yus"
    private let decryptionKeyLong = "6YusQqtbwPMT3Kt66YusQqtbwPMT3Kt66YusQqtbwPMT3Kt66YusQqtbwPMT3Kt6"

    private let testDataString = "test_data"
    private let decryptedTestDataString = "uj3IgJELOCLt"

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Encryption tests

    /// Testing if encryption is the same for same data
    func testAES128SameEncryptTest() {
        XCTAssertNotNil(testDataString.data(using: .utf8), "Expected not nil data.")

        XCTAssertEqual(EncryptionManager.aes128Encrypt(data: testDataString.data(using: .utf8)!, withKey: decryptionKey), EncryptionManager.aes128Encrypt(data: testDataString.data(using: .utf8)!, withKey: decryptionKey))
    }

    /// Testing if encryptions is different for different data
    func testAES128DifferentEncrypionTest() {
        let firstData = "first_data".data(using: .utf8)
        let secondData = "second_data".data(using: .utf8)

        XCTAssertNotNil(firstData, "Expected not nil first data.")
        XCTAssertNotNil(secondData, "Expected not nil second data.")
        XCTAssertNotEqual(EncryptionManager.aes128Encrypt(data: firstData!, withKey: decryptionKey), EncryptionManager.aes128Encrypt(data: secondData!, withKey: decryptionKey))
    }

    /// Testing if encrypting of same data with different keys is the same
    func testAES128DifferentKeyEncryptionTest() {
        let decryptionKeyOne = "6YusQqtbwPMT3Kt6"
        let decryptionKeyTwo = "6YusQqtbwPMT3Kt8"

        XCTAssertNotEqual(EncryptionManager.aes128Encrypt(data: testDataString.data(using: .utf8)!, withKey: decryptionKeyOne), EncryptionManager.aes128Encrypt(data: testDataString.data(using: .utf8)!, withKey: decryptionKeyTwo))
    }

    /// Testing encryption of encrypted data (two times encrypting)
    func testAES128TwoTimesEncrypting() {
        XCTAssertNotEqual(EncryptionManager.aes128Encrypt(data: testDataString.data(using: .utf8)!, withKey: decryptionKey), EncryptionManager.aes128Encrypt(data: EncryptionManager.aes128Encrypt(data: testDataString.data(using: .utf8)!, withKey: decryptionKey)!, withKey: decryptionKey))
    }

    /// Testing encryption with too short key
    func testAES128EncryptTooShortKey() {
        XCTAssertNil(EncryptionManager.aes128Encrypt(data: testDataString.data(using: .utf8)!, withKey: decryptionKeyShort))
    }

    /// Testing encryption with too long key
    func testAES128EncryptTooLongKey() {
        XCTAssertNil(EncryptionManager.aes128Encrypt(data: testDataString.data(using: .utf8)!, withKey: decryptionKeyLong))
    }

    /// Testing encryption expected result
    func testAES128ExpectedEncryptionResult() {
        XCTAssertEqual(EncryptionManager.aes128Encrypt(data: testDataString.data(using: .utf8)!, withKey: decryptionKey)!.base64EncodedString(), decryptedTestDataString)
    }

}
