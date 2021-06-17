//
//  DataTests.swift
//  NDBluetoothLibraryTests
//
//  Created by Goran Tokovic on 17.6.21..
//

@testable import NDBluetoothLibrary
import XCTest

class DataTests: XCTestCase {

    /**
     This method test converting Data object to the HEX string.

     After setting input data `0x01343f7e` the methog shoul return String with value `0x01343f7e`
     */
    func testHexEncodedString() {
        let byteArray: [UInt8] = [0x01, 0x34, 0x3f, 0x7e]
        let data: Data = Data(byteArray)
        XCTAssertEqual(data.hexEncodedString(), "0x01343F7E")
    }
}
