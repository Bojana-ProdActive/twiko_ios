//
//  RegimenManagerTests.swift
//  NDBluetoothLibraryTests
//
//  Created by Goran Tokovic on 30.6.21..
//

@testable import NDBluetoothLibrary
import XCTest

class MockRegimenDownloader: RegimenDownloaderInterface {

    var error: NSError = NSError(domain: "tests", code: -1, userInfo: nil)
    var regimens: [PumpRegimen]?
    var _isDownloading: Bool = false

    var isDownloading: Bool {
        return _isDownloading
    }

    func download(_ handler: ((Result<[PumpRegimen], Error>) -> Void)?) {
        if let regimens = regimens {
            handler?(.success(regimens))
        } else {
            handler?(.failure(error))
        }
    }
}

class RegimenManagerTests: XCTestCase {

    var regimenDownloader: MockRegimenDownloader = MockRegimenDownloader()
    var sut: RegimenManager!

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = RegimenManager(regimenDownloader: regimenDownloader)
    }

    func testStartRegimenDownloadWhenDownloadingIsInProgress_ShouldReturnError() {
        regimenDownloader._isDownloading = true
        regimenDownloader.regimens = createFakeRegimens()

        sut.download { result in
            switch result {
            case .success:
                XCTFail("Result should be failure because downloading is in progress")
            case .failure(let error):
                XCTAssertEqual(RegimenDownloader.DownloaderError.downloadRegimensIsUnavailable, error as! RegimenDownloader.DownloaderError)
            }
        }
    }

    func testDownloadRegimens_ErrorOccurs_ShouldReturnError() {
        regimenDownloader._isDownloading = false
        sut.download { result in
            switch result {
            case .success:
                XCTFail("Result should be failure because error occured on regimen downloader")
            case .failure(let error):
                XCTAssertEqual(error as NSError, self.regimenDownloader.error)
            }
        }
    }

    func testDownloadRegimens_ShouldReturnReadRegimens() {
        regimenDownloader._isDownloading = false
        regimenDownloader.regimens = createFakeRegimens()

        sut.download { result in
            switch result {
            case .success(let regimens):
                XCTAssertEqual(regimens, self.regimenDownloader.regimens)
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTFail("Result should be failure because error occured on regimen downloader")
            }
        }
    }

    func createFakeRegimens() -> [PumpRegimen] {
        let segment1 = PumpRegimenSegment(startTime: 123, value: 123)
        let segment2 = PumpRegimenSegment(startTime: 987, value: 987)
        return [PumpRegimen(segments: [segment1, segment2])]
    }
}
