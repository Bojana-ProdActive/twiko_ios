//
//  DecryptionManagerTest.swift
//  NDBluetoothLibraryTests
//
//  Created by Digital Atrium on 7.6.21..
//
@testable import NDBluetoothLibrary
import XCTest

class DecryptionManagerTest: XCTestCase {

    private let aesDecryptionKey = "6YusQqtbwPMT3Kt6"
    private  let qrDecriptionKey = "1234567896543210"
    private let decryptionKeyShort = "6Yus"
    private let decryptionKeyLong = "6YusQqtbwPMT3Kt66YusQqtbwPMT3Kt66YusQqtbwPMT3Kt66YusQqtbwPMT3Kt6"

    private let testDataString = "test_data"
    private let decryptedTestDataString = "uj3IgJELOCLt"

    private let qrStringTest = "test\ntest\rtest"
    private let qrDecryptedDataExpectedResult = "LeZNNHSIJ+8E49MFInftFQ=="

    // MARK: - Aes 128 decrypt tests

    /// Testing if decrypting is the same for same data
    func testAES128SameDecryptTest() {
        XCTAssertNotNil(testDataString.data(using: .utf8), "Expected not nil data.")

        XCTAssertEqual(DecryptionManager.aes128Decrypt(data: testDataString.data(using: .utf8)!, withKey: aesDecryptionKey), DecryptionManager.aes128Decrypt(data: testDataString.data(using: .utf8)!, withKey: aesDecryptionKey))
    }

    /// Testing if decrypting is the different for different data
    func testAES128DifferentDecryptTest() {
        let firstData = "first_data".data(using: .utf8)
        let secondData = "second_data".data(using: .utf8)

        XCTAssertNotNil(firstData, "Expected not nil first data.")
        XCTAssertNotNil(secondData, "Expected not nil second data.")

        XCTAssertNotEqual(DecryptionManager.aes128Decrypt(data: firstData!, withKey: aesDecryptionKey), DecryptionManager.aes128Decrypt(data: secondData!, withKey: aesDecryptionKey))

    }

    /// Testing if decrypting of same data with different keys is the same
    func testAES128DifferentKeyTest() {
        let decryptionKeyOne = "6YusQqtbwPMT3Kt6"
        let decryptionKeyTwo = "6YusQqtbwPMT3Kt8"

        XCTAssertNotEqual(DecryptionManager.aes128Decrypt(data: testDataString.data(using: .utf8)!, withKey: decryptionKeyOne), DecryptionManager.aes128Decrypt(data: testDataString.data(using: .utf8)!, withKey: decryptionKeyTwo))
    }

    /// Testing decryption of decrypted data (two times decrypting)
    func testAES128TwoTimesDecrypting() {
            XCTAssertNotEqual(DecryptionManager.aes128Decrypt(data: testDataString.data(using: .utf8)!, withKey: aesDecryptionKey), DecryptionManager.aes128Decrypt(data: DecryptionManager.aes128Decrypt(data: testDataString.data(using: .utf8)!, withKey: aesDecryptionKey)!, withKey: aesDecryptionKey))
    }

    /// Testing decryption with too short key
    func testAES128DecryptTooShortKey() {
        XCTAssertNil(DecryptionManager.aes128Decrypt(data: testDataString.data(using: .utf8)!, withKey: decryptionKeyShort))
    }

    /// Testing decryption with too long key
    func testAES128DecryptTooLongKey() {
        XCTAssertNil(DecryptionManager.aes128Decrypt(data: testDataString.data(using: .utf8)!, withKey: decryptionKeyLong))
    }

    /// Testing decryption expected result
    func testAES128ExpectedDecryptionResult() {
        XCTAssertEqual(DecryptionManager.aes128Decrypt(data: testDataString.data(using: .utf8)!, withKey: aesDecryptionKey)!.base64EncodedString(), decryptedTestDataString)
    }

    // MARK: - QR Decrypt Tests

    /// Testing if decrypting is the same for same data
    func testQRSameDecryptTest() {
        XCTAssertNotNil(testDataString.data(using: .utf8), "Expected not nil data.")

        XCTAssertEqual(DecryptionManager.aesDecryptQR(data: testDataString.data(using: .utf8)!, withKey: qrDecriptionKey), DecryptionManager.aesDecryptQR(data: testDataString.data(using: .utf8)!, withKey: qrDecriptionKey))
    }

    /// Testing decryption with too short key
    func testQRDecryptTooShortKeyTest() {
        XCTAssertNil(DecryptionManager.aesDecryptQR(data: testDataString.data(using: .utf8)!, withKey: decryptionKeyShort))
    }

    /// Testing decryption with too long key
    func testQRDecryptTooLongKeyTest() {
        XCTAssertNil(DecryptionManager.aesDecryptQR(data: testDataString.data(using: .utf8)!, withKey: decryptionKeyLong))
    }

    /// Testing decryption expected result
    func testQRDecryptBadKeyTest() {
        let badExeptedResultData = "Bad expected result".data(using: .utf8)

        XCTAssertNotNil(DecryptionManager.aesDecryptQR(data: qrStringTest.data(using: .utf8)!, withKey: qrDecriptionKey), "Expected not nil data.")

        XCTAssertNotEqual(DecryptionManager.aesDecryptQR(data: qrStringTest.data(using: .utf8)!, withKey: qrDecriptionKey), badExeptedResultData)
    }

}
