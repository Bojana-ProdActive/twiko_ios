//
//  PumpManagerTests.swift
//  NDBluetoothLibraryTests
//
//  Created by Goran Tokovic on 17.6.21..
//

import CoreBluetooth
@testable import NDBluetoothLibrary
import XCTest

class ConnectionManagerMock: ConnectionManagerInterface {
    var responseError: Error?
    var responseData: Data?
    var writeData: Data?
    var writeCharacteristicType: CharacteristicType?
    var readCharacteristicType: CharacteristicType?
    var hasWriteCalled: Bool = false
    var hasReadCalled: Bool = false

    func scannDevices(withCBUUIDs cbuuids: [CBUUID]) {

    }

    func stopScanningForDevices() {

    }

    func connect(_ peripheral: Peripheral) {

    }

    func write(_ data: Data, characteristicType: CharacteristicType, handler: ((Result<Data?, Error>) -> Void)?) {
        hasWriteCalled = true
        writeData = data
        writeCharacteristicType = characteristicType
        if let error = responseError {
            handler?(.failure(error))
        } else {
            handler?(.success(responseData))
        }
    }

    func read(_ characteristicType: CharacteristicType, handler: ((Result<Data?, Error>) -> Void)?) {
        hasReadCalled = true
        readCharacteristicType = characteristicType
        if let error = responseError {
            handler?(.failure(error))
        } else {
            handler?(.success(responseData))
        }
    }
}

class PumpManagerTests: XCTestCase {

    var connectionManager: ConnectionManagerMock!
    var sut: PumpManager!
    var defaultError: Error = NSError(domain: "com.ndlibrary.test", code: -1)
    var pumpCommandTimeout: TimeInterval = 3

    override func setUpWithError() throws {
        try super.setUpWithError()

        connectionManager = ConnectionManagerMock()
        sut = PumpManager()
        sut.connectinManager = connectionManager
    }

    /**
     Testing the sending of the `Finish Ftu` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `success` as result in callback block
     - Is write method called on `ConnetionManager` object: true
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.finishFtu`
     */
    func testSendFinishFtuCommand_ShouldReturnSuccess() {
        let expectation = expectation(description: "Sending the pump command")

        sut.sendFinishFtuCommand { result in
            expectation.fulfill()
            self.vaildateSuccessPumpCommandResult(result, commandType: .finishFtu)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Finish Ftu` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `failure` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.finishFtu`
     */
    func testSendFinishFtuCommand_ShouldReturnError() {
        let expectation = expectation(description: "Sending the pump command")
        connectionManager.responseError = defaultError

        sut.sendFinishFtuCommand { result in
            expectation.fulfill()
            self.vaildateFailurePumpCommandResult(result, commandType: .finishFtu)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Turn Off` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `success` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.turnOff`
     */
    func testSendTurnOffCommand_ShouldReturnSuccess() {
        let expectation = expectation(description: "Sending the pump command")

        sut.sendTurnOffCommand { result in
            expectation.fulfill()
            self.vaildateSuccessPumpCommandResult(result, commandType: .turnOffThePump)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Turn Off` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `failure` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.turnOff`
     */
    func testSendTurnOffCommand_ShouldReturnError() {
        let expectation = expectation(description: "Sending the pump command")
        connectionManager.responseError = defaultError

        sut.sendTurnOffCommand { result in
            expectation.fulfill()
            self.vaildateFailurePumpCommandResult(result, commandType: .turnOffThePump)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Disconnect` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `success` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.disconnect`
     */
    func testSendDisconnectCommand_ShouldReturnSuccess() {
        let expectation = expectation(description: "Sending the pump command")

        sut.sendDisconnectCommand { result in
            expectation.fulfill()
            self.vaildateSuccessPumpCommandResult(result, commandType: .disconnect)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Disconnect` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `failure` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.disconnect`
     */
    func testSendDisconnectCommand_ShouldReturnError() {
        let expectation = expectation(description: "Sending the pump command")
        connectionManager.responseError = defaultError

        sut.sendDisconnectCommand { result in
            expectation.fulfill()
            self.vaildateFailurePumpCommandResult(result, commandType: .disconnect)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Start regimen download` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `success` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.startRegimenDownload`
     */
    func testSendStartRegimenDownloadCommand_ShouldReturnSuccess() {
        let expectation = expectation(description: "Sending the pump command")

        sut.sendStartRegimenDownloadCommand { result in
            expectation.fulfill()
            self.vaildateSuccessPumpCommandResult(result, commandType: .startRegimenDownload)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Start regimen download` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `failure` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.startRegimenDownload`
     */
    func testSendStartRegimenDownloadCommand_ShouldReturnError() {
        let expectation = expectation(description: "Sending the pump command")
        connectionManager.responseError = defaultError

        sut.sendStartRegimenDownloadCommand { result in
            expectation.fulfill()
            self.vaildateFailurePumpCommandResult(result, commandType: .startRegimenDownload)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Start regimen upload` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `success` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.startRegimenUpload`
     */
    func testSendStartRegimenUploadCommand_ShouldReturnSuccess() {
        let expectation = expectation(description: "Sending the pump command")

        sut.sendStartRegimenUploadCommand { result in
            expectation.fulfill()
            self.vaildateSuccessPumpCommandResult(result, commandType: .startRegimenUpload)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Start regimen upload` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `failure` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.startRegimenUpload`
     */
    func testSendStartRegimenUploadCommand_ShouldReturnError() {
        let expectation = expectation(description: "Sending the pump command")
        connectionManager.responseError = defaultError

        sut.sendStartRegimenUploadCommand { result in
            expectation.fulfill()
            self.vaildateFailurePumpCommandResult(result, commandType: .startRegimenUpload)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Finish regimen upload` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `success` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.finishRegimenUpload`
     */
    func testSendFinishRegimenUploadCommand_ShouldReturnSuccess() {
        let expectation = expectation(description: "Sending the pump command")

        sut.sendFinishRegimenUploadCommand { result in
            expectation.fulfill()
            self.vaildateSuccessPumpCommandResult(result, commandType: .finishRegimenUpload)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Finish regimen upload` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `failure` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.finishRegimenUpload`
     */
    func testSendFinishRegimenUploadCommand_ShouldReturnError() {
        let expectation = expectation(description: "Sending the pump command")
        connectionManager.responseError = defaultError

        sut.sendFinishRegimenUploadCommand { result in
            expectation.fulfill()
            self.vaildateFailurePumpCommandResult(result, commandType: .finishRegimenUpload)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Unpair` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `success` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.unpair`
     */
    func testSendUnpairCommand_ShouldReturnSuccess() {
        let expectation = expectation(description: "Sending the pump command")

        sut.sendUnpairCommand { result in
            expectation.fulfill()
            self.vaildateSuccessPumpCommandResult(result, commandType: .unpair)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Unpair` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `failure` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.unpair`
     */
    func testSendUnpairCommand_ShouldReturnError() {
        let expectation = expectation(description: "Sending the pump command")
        connectionManager.responseError = defaultError

        sut.sendUnpairCommand { result in
            expectation.fulfill()
            self.vaildateFailurePumpCommandResult(result, commandType: .unpair)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Start filling medication` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `success` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.startFillingMedication`
     */
    func testSendStartFillingMedicationCommand_ShouldReturnSuccess() {
        let expectation = expectation(description: "Sending the pump command")

        sut.sendStartFillingMedicationCommand { result in
            expectation.fulfill()
            self.vaildateSuccessPumpCommandResult(result, commandType: .startFillingMedication)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Start filling medication` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `failure` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.startFillingMedication`
     */
    func testSendStartFillingMedicationCommand_ShouldReturnError() {
        let expectation = expectation(description: "Sending the pump command")
        connectionManager.responseError = defaultError

        sut.sendStartFillingMedicationCommand { result in
            expectation.fulfill()
            self.vaildateFailurePumpCommandResult(result, commandType: .startFillingMedication)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Start priming` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `success` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.startPriming`
     */
    func testSendStartPrimingCommand_ShouldReturnSuccess() {
        let expectation = expectation(description: "Sending the pump command")

        sut.sendStartPrimingCommand { result in
            expectation.fulfill()
            self.vaildateSuccessPumpCommandResult(result, commandType: .startPriming)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Start priming` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `failure` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.startPriming`
     */
    func testSendStartPrimingCommand_ShouldReturnError() {
        let expectation = expectation(description: "Sending the pump command")
        connectionManager.responseError = defaultError

        sut.sendStartPrimingCommand { result in
            expectation.fulfill()
            self.vaildateFailurePumpCommandResult(result, commandType: .startPriming)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Start watchdog test` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `success` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.startWatchdogTest`
     */
    func testSendStartWatchdogTestCommand_ShouldReturnSuccess() {
        let expectation = expectation(description: "Sending the pump command")

        sut.sendStartWatchdogTestCommand { result in
            expectation.fulfill()
            self.vaildateSuccessPumpCommandResult(result, commandType: .startWatchdogTest)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Start watchdog test` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `failure` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.startWatchdogTest`
     */
    func testSendStartWatchdogTestCommand_ShouldReturnError() {
        let expectation = expectation(description: "Sending the pump command")
        connectionManager.responseError = defaultError

        sut.sendStartWatchdogTestCommand { result in
            expectation.fulfill()
            self.vaildateFailurePumpCommandResult(result, commandType: .startWatchdogTest)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Clear pump log` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `success` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.clearPumpLog`
     */
    func testSendClearPumpLogCommand_ShouldReturnSuccess() {
        let expectation = expectation(description: "Sending the pump command")

        sut.sendClearPumpLogCommand { result in
            expectation.fulfill()
            self.vaildateSuccessPumpCommandResult(result, commandType: .clearPumpLog)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Clear pump log` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `failure` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.clearPumpLog`
     */
    func testSendClearPumpLogCommand_ShouldReturnError() {
        let expectation = expectation(description: "Sending the pump command")
        connectionManager.responseError = defaultError

        sut.sendClearPumpLogCommand { result in
            expectation.fulfill()
            self.vaildateFailurePumpCommandResult(result, commandType: .clearPumpLog)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Switch to filling state` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `success` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.switchToFillState`
     */
    func testSendSwitchToFillStateCommand_ShouldReturnSuccess() {
        let expectation = expectation(description: "Sending the pump command")

        sut.sendSwitchToFillStateCommand { result in
            expectation.fulfill()
            self.vaildateSuccessPumpCommandResult(result, commandType: .switchToFillState)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Switch to filling state` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `failure` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.switchToFillState`
     */
    func testSendSwitchToFillStateCommand_ShouldReturnError() {
        let expectation = expectation(description: "Sending the pump command")
        connectionManager.responseError = defaultError

        sut.sendSwitchToFillStateCommand { result in
            expectation.fulfill()
            self.vaildateFailurePumpCommandResult(result, commandType: .switchToFillState)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Stop logs download` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `success` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.stopLogsDownload`
     */
    func testSendStopLogsDownloadCommand_ShouldReturnSuccess() {
        let expectation = expectation(description: "Sending the pump command")

        sut.sendStopLogsDownloadCommand { result in
            expectation.fulfill()
            self.vaildateSuccessPumpCommandResult(result, commandType: .stopLogsDownload)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Stop logs download` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `failure` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.stopLogsDownload`
     */
    func testSendStopLogsDownloadCommand_ShouldReturnError() {
        let expectation = expectation(description: "Sending the pump command")
        connectionManager.responseError = defaultError

        sut.sendStopLogsDownloadCommand { result in
            expectation.fulfill()
            self.vaildateFailurePumpCommandResult(result, commandType: .stopLogsDownload)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Send the pump to the bootloader` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `success` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.sendThePumpToTheBootloader`
     */
    func testSendThePumpToTheBoothloaderCommand_ShouldReturnSuccess() {
        let expectation = expectation(description: "Sending the pump command")

        sut.sendThePumpToTheBoothloaderCommand { result in
            expectation.fulfill()
            self.vaildateSuccessPumpCommandResult(result, commandType: .sendThePumpToTheBootloader)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Send the pump to the bootloader` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `failure` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.sendThePumpToTheBootloader`
     */
    func testSendThePumpToTheBoothloaderCommand_ShouldReturnError() {
        let expectation = expectation(description: "Sending the pump command")
        connectionManager.responseError = defaultError

        sut.sendThePumpToTheBoothloaderCommand { result in
            expectation.fulfill()
            self.vaildateFailurePumpCommandResult(result, commandType: .sendThePumpToTheBootloader)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Acknowledge Alarm` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `success` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.acknowledgeAlarm`
     */
    func testSendAcknowledgeAlarmCommand_ShouldReturnSuccess() {
        let expectation = expectation(description: "Sending the pump command")

        sut.sendAcknowledgeAlarmCommand { result in
            expectation.fulfill()
            self.vaildateSuccessPumpCommandResult(result, commandType: .acknowledgeAlarm)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Acknowledge Alarm` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `failure` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.acknowledgeAlarm`
     */
    func testSendAcknowledgeAlarmCommand_ShouldReturnError() {
        let expectation = expectation(description: "Sending the pump command")
        connectionManager.responseError = defaultError

        sut.sendAcknowledgeAlarmCommand { result in
            expectation.fulfill()
            self.vaildateFailurePumpCommandResult(result, commandType: .acknowledgeAlarm)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Keep alive` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `success` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.keepAlive`
     */
    func testSendKeepAliveCommand_ShouldReturnSuccess() {
        let expectation = expectation(description: "Sending the pump command")

        sut.sendKeepAliveCommand { result in
            expectation.fulfill()
            self.vaildateSuccessPumpCommandResult(result, commandType: .keepAlive)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Keep alive` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `failure` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.keepAlive`
     */
    func testSendKeepAliveCommand_ShouldReturnError() {
        let expectation = expectation(description: "Sending the pump command")
        connectionManager.responseError = defaultError

        sut.sendKeepAliveCommand { result in
            expectation.fulfill()
            self.vaildateFailurePumpCommandResult(result, commandType: .keepAlive)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Reset FTU and send to ship mode` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `success` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.resetFtuAndSendToShipMode`
     */
    func testSendResetFtuAndSendToShipModeCommand_ShouldReturnSuccess() {
        let expectation = expectation(description: "Sending the pump command")

        sut.sendResetFtuAndSendToShipModeCommand { result in
            expectation.fulfill()
            self.vaildateSuccessPumpCommandResult(result, commandType: .resetFtuAndSendToShipMode)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    /**
     Testing the sending of the `Reset FTU and send to ship mode` command to the pump

     After calling the method, the following events should be performed in the block block
     - Is returned `failure` as result in callback block
     - Is write method called on `ConnetionManager` object
     - Is characteristic equal to `CharacteristicType.pumpCommand`
     - Is written data equal to the `PumpCommandType.resetFtuAndSendToShipMode`
     */
    func testSendResetFtuAndSendToShipModeCommand_ShouldReturnError() {
        let expectation = expectation(description: "Sending the pump command")
        connectionManager.responseError = defaultError

        sut.sendResetFtuAndSendToShipModeCommand { result in
            expectation.fulfill()
            self.vaildateFailurePumpCommandResult(result, commandType: .resetFtuAndSendToShipMode)
        }

        waitForExpectations(timeout: pumpCommandTimeout, handler: nil)
    }

    // MARK: - Private

    func vaildateSuccessPumpCommandResult(_ result: Result<Bool, Error>, commandType: PumpCommandType) {
        switch result {
        case .success(let temp):
            XCTAssertTrue(self.connectionManager.hasWriteCalled)
            XCTAssertEqual(self.connectionManager.writeCharacteristicType, CharacteristicType.pumpCommand)
            XCTAssertTrue(temp)
            let writeValue: [UInt8] = [commandType.rawValue]
            XCTAssertEqual(self.connectionManager.writeData, Data(writeValue))
        case .failure:
            XCTFail("Result should be success")
        }
    }

    func vaildateFailurePumpCommandResult(_ result: Result<Bool, Error>, commandType: PumpCommandType) {
        switch result {
        case .success:
            XCTFail("Result should error")
        case .failure:
            XCTAssertTrue(self.connectionManager.hasWriteCalled)
            XCTAssertEqual(self.connectionManager.writeCharacteristicType, CharacteristicType.pumpCommand)
            let writeValue: [UInt8] = [commandType.rawValue]
            XCTAssertEqual(self.connectionManager.writeData, Data(writeValue))
        }
    }
}
