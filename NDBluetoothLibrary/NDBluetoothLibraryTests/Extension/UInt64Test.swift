//
//  UInt64Test.swift
//  NDBluetoothLibraryTests
//
//  Created by Digital Atrium on 24.6.21..
//
@testable import NDBluetoothLibrary
import XCTest

class UInt64Test: XCTestCase {

    var expectedByteDataValue = Data([0x00, 0x00, 0x00, 0x00, 0x61, 0xBE, 0xA3, 0xCB])
    var time: UInt64!

    override func setUpWithError() throws {
        try super.setUpWithError()

        time = UInt64(1639883723)
    }

    /**
     Testing conversion to byte array.

     After calling the method for time value = 1639883723, the following events should be performed:
     - `expectedByteDataValue` = Data([0x00, 0x00, 0x00, 0x00, 0x61, 0xBE, 0xA3, 0xCB])
     */
    func testConversionUInt64ToDataBytArray_ShouldBeEqual() {
        let convertedData = time.getDataByteArray()

        XCTAssertEqual(convertedData, expectedByteDataValue)
    }

    /**
     Testing conversion to byte array.

     After calling the method for time value = 458785253, the following events should be performed:
     - `expectedByteDataValue` =  Data([0x00, 0x00, 0x00, 0x00, 0x61, 0xBE, 0xA3, 0xCB]) won't be equal as converted data.
     */
    func testConversionUInt64ToDataBytArray_ShouldBeNotEqual() {
        time = 458785253
        let convertedData = time.getDataByteArray()

        XCTAssertNotEqual(convertedData, expectedByteDataValue)
    }

}
