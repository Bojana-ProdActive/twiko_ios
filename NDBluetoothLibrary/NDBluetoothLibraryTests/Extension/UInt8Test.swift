//
//  UInt8Test.swift
//  NDBluetoothLibraryTests
//
//  Created by Digital Atrium on 16.6.21..
//
@testable import NDBluetoothLibrary
import XCTest

class UInt8Test: XCTestCase {

    private let bitOne = Bit(rawValue: 1)
    private let bitZero = Bit(rawValue: 0)

    func testBitOneDescryption() {
        XCTAssertEqual(bitOne?.description, "1")
    }

    func testBitZeroDescryption() {
        XCTAssertEqual(bitZero?.description, "0")
    }

    func testBitOneBoolValue() {
        guard let bitOne = bitOne else {
            XCTAssertFalse(true)
            return
        }
        XCTAssertTrue(bitOne.boolValue)
    }

    func testBitZeroBoolValue() {
        guard let bitZero = bitZero else {
            XCTAssertFalse(true)
            return
        }
        XCTAssertFalse(bitZero.boolValue)
    }

}
