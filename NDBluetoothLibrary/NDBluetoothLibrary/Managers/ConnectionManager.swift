////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// ConnectionManager.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        27.5.21.
//
////////////////////////////////////////////////////////////////////////////////
import CoreBluetooth
import Foundation
////////////////////////////////////////////////////////////////////////////////
protocol ConnectionManagerDelegate: AnyObject {
    func peripheralListUpdated(_ peripherals: [Peripheral])
    func connectionFailed(error: Error?)
    func connectionSuccess()
    func didDisconnectPeripheral(_ peripheral: CBPeripheral, error: Error?)
    func didUpdateValue(forCharacteristic characteristic: CBCharacteristic, error: Error?)
    func pumpVersion(_ pumpVersion: PumpVersion)
    func authorizaionKey(_ key: Data)
}

protocol ConnectionManagerInterface {

    var connectedPumpName: String? { get }

    /**
     Configure Connection manager before usage. It should be called once.
     */
    func configure()

    /// Scan for devices with passed CBUUUID-s in range.
    /// - Parameters:
    ///   - cbuuids: List of CBUUIDs which will can be found in search process
    ///   - handler: Completion handler
    func scannDevices(withCBUUIDs cbuuids: [CBUUID])

    /// Stop searching for devices in range
    func stopScanningForDevices()

    /**
     Make connection with pump and exchange bounding keys.

     This method trigger pairing, pump select and write defautl authorization key.
     For every next connection use **func reconnect(_ peripheral: Peripheral, authorizationData: Data, authorizationEnabled: Bool)**
     - parameter peripheral: A peripheral object that retains a reference to the pump we want to connect to us
     - parameter authorizationEnabled: Is authorization mandatory or it can be skipped. For `false` authorization will be  skipped.
     */
    func connectFirstTime(_ peripheral: Peripheral, authorizationEnabled: Bool)

    /**
     Connect to the pump that exchanged the bounding key.

     Connect on paired pump.
     - parameter peripheral: A peripheral object that retains a reference to the pump we want to connect to us
     - parameter authorizationData: Data object that represent authorization key
     - parameter authorizationEnabled: Is authorization mandatory or it can be skipped. For `false` authorization will be  skipped.
     */
    func reconnect(_ peripheral: Peripheral, authorizationData: Data, authorizationEnabled: Bool)

    /**
     Returns a list of known peripherals by their identifiers.
     - parameter identifier: A peripheral identifiers from which CBPeripheral objects can be retrieved.
     - returns: A list of peripherals that the central manager is able to match to the provided identifier.
     */
    func retrievePeripheral(withIdentifier identifier: String) -> [Peripheral]

    /**
     Disconnect from the pump.

     Disconnectiong from connected pump and removes all commands from priority queue.
     */
    func disconnectThePump()

    /// Write value for characteristic with passed type.
    /// - Parameters:
    ///   - data: Data object which should be sent to peripheral
    ///   - characteristicType: Characteristic type
    ///   - handler: callback handler
    func write(_ data: Data, characteristicType: CharacteristicType, handler: ((_ result: Result<Data?, Error>) -> Void)?)

    /// Read value for characteristic with type
    /// - Parameters:
    ///   - characteristicType: The characteristic which value needs to be read
    ///   - handler: callback handler
    func read(_ characteristicType: CharacteristicType, handler: ((_ result: Result<Data?, Error>) -> Void)?)

    /**
     Remove all commands from priority queue.
     */
    func clearCommandQueue()
}

extension ConnectionManager {
    enum State {
        /// Connection is in progress
        case connecting

        /// Connected but can't get data from pump
        case connected

        /// Connected and CS can work with pump
        case initialized

        /// CS starts disconnecting, CS can't read or write data
        case disconnecting

        /// CS completes disconnection
        case disconnected

        /// Pump initialized disconnection
        case disconnectedWithError
    }
}

final class ConnectionManager: NSObject, ConnectionManagerInterface {
    private lazy var queue: DispatchQueue = DispatchQueue(label: "con.neuroderm.bluetoooth.central-manager.main", qos: .background)
    private lazy var centralManager: CBCentralManager = CBCentralManager(delegate: self, queue: queue)

    var stateUpdatedHandler: ((CBManagerState) -> Void)?
    var connectedPumpName: String?

    private var cbuuidArray: [CBUUID]?
    private var discoveredPeripherals: [Peripheral] = []
    private var connectablePeripheral: Peripheral?
    private var connectedPeripheral: Peripheral?
    private var priorityQueue: PriorityQueue<PriorityCommand> = PriorityQueue(ascending: true)
    private var executingCommand: PriorityCommand?

    private(set) var state: State = .disconnected
    private var services: [Service] = []
    private var searchingForDevices: Bool = false
    private var isConfigured: Bool = false
    private var isFirstTimeConnect: Bool = true
    private var authorizationData: Data?

    private let defaultAuthorizationData: Data = {
        let value: [UInt8] = [0x01, 0xa3, 0x19, 0xf6, 0xe8]
        return Data(value)
    }()

    private var pumpInitError: Error?

    private weak var delegate: ConnectionManagerDelegate?
    private var authorizationEnabled: Bool = true

    init(delegate: ConnectionManagerDelegate) {
        self.delegate = delegate
        super.init()
    }

    func configure() {
        guard !isConfigured else {
            return
        }

        isConfigured.toggle()

        // Init central manager because it is lazy property
        _ = centralManager.state
    }

    /// Scan for devices with passed CBUUUID-s in range.
    /// - Parameters:
    ///   - cbuuids: List of CBUUIDs which will can be found in search process
    ///   - handler: Completion handler
    func scannDevices(withCBUUIDs cbuuids: [CBUUID]) {
        queue.sync {
            guard !searchingForDevices else {
                Log.d("Scan has already started")
                return
            }
            Log.i("Started")
            searchingForDevices = true
            cbuuidArray = cbuuids
            discoveredPeripherals = []
            startSearchingPeripherals()
        }
    }

    /// Stop searching for devices in range
    func stopScanningForDevices() {
        queue.sync {
            guard centralManager.isScanning else {
                Log.d("Scanning has already stopped")
                return
            }
            Log.i("Stopped")
            centralManager.stopScan()
            searchingForDevices = false
            cbuuidArray = nil
        }
    }

    /// Make connection with peripheral object
    /// - Parameter peripheral: periferal object which keeps reference on CBPeripheral object
    func connectFirstTime(_ peripheral: Peripheral, authorizationEnabled: Bool = true) {
        queue.sync {
            guard state == .disconnected || state == .disconnectedWithError else {
                Log.e("Connection is not allowed")
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.connectionFailed(error: NDBluetoothError.connectionHasNotAllowed)
                }
                return
            }

            Log.i("Connection started")
            isFirstTimeConnect = true
            self.authorizationEnabled = authorizationEnabled
            state = .connecting
            connectablePeripheral = peripheral
            services = []
            centralManager.connect(peripheral.cbPeripheral, options: nil)
        }
    }

    func reconnect(_ peripheral: Peripheral, authorizationData: Data, authorizationEnabled: Bool) {
        queue.sync {
            guard state == .disconnected || state == .disconnectedWithError else {
                Log.e("Connection is not allowed")
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.connectionFailed(error: NDBluetoothError.connectionHasNotAllowed)
                }
                return
            }

            Log.i("Connection started")
            isFirstTimeConnect = false
            self.authorizationEnabled = authorizationEnabled
            self.authorizationData = authorizationData
            state = .connecting
            connectablePeripheral = peripheral
            services = []
            centralManager.connect(peripheral.cbPeripheral, options: nil)
        }
    }

    func retrievePeripheral(withIdentifier identifier: String) -> [Peripheral] {
        if let uuid = UUID(uuidString: identifier) {
            return centralManager.retrievePeripherals(withIdentifiers: [uuid]).map { Peripheral(name: $0.name ?? "", peripheral: $0) }
        }
        return []
    }

    func disconnectThePump() {
        Log.d("state: \(state)")
        guard state == .connected || state == .connecting || state == .initialized else {
            Log.d("From \(state) state is not possible disconnection")
            return
        }

        guard let peripheral = connectedPeripheral?.cbPeripheral else {
            Log.d("There is not connected pump")
            return
        }

        // Remove all commands from the command queue
        priorityQueue.clear()

        // Start disconection
        centralManager.cancelPeripheralConnection(peripheral)
    }

    /// Write value for characteristic with passed type.
    /// - Parameters:
    ///   - data: Data object which should be sent to peripheral
    ///   - characteristicType: Characteristic type
    ///   - handler: callback handler
    func write(_ data: Data, characteristicType: CharacteristicType, handler: ((_ result: Result<Data?, Error>) -> Void)?) {
        queue.sync {
            guard let characteristic = characteristic(withType: characteristicType, services: services) else {
                DispatchQueue.main.async {
                    handler?(.failure(NDBluetoothError.characteristicIsNotDiscovered))
                }
                return
            }

            guard connectedPeripheral != nil else {
                DispatchQueue.main.async {
                    handler?(.failure(NDBluetoothError.pumpHasNotConnected))
                }
                return
            }

            let command = PriorityCommand(type: .write(data),
                                          priority: characteristic.type.priority,
                                          characteristic: characteristic,
                                          handler: handler)
            priorityQueue.push(command)
            executeNextCommand()
        }
    }

    /// Read value for characteristic with type
    /// - Parameters:
    ///   - characteristicType: The characteristic which value needs to be read
    ///   - handler: callback handler
    func read(_ characteristicType: CharacteristicType, handler: ((_ result: Result<Data?, Error>) -> Void)?) {
        queue.sync {
            guard let characteristic = characteristic(withType: characteristicType, services: services) else {
                DispatchQueue.main.async {
                    handler?(.failure(NDBluetoothError.characteristicIsNotDiscovered))
                }
                return
            }

            guard connectedPeripheral != nil else {
                DispatchQueue.main.async {
                    handler?(.failure(NDBluetoothError.pumpHasNotConnected))
                }
                return
            }

            let command = PriorityCommand(type: .read,
                                          priority: characteristic.type.priority,
                                          characteristic: characteristic,
                                          handler: handler)
            priorityQueue.push(command)
            executeNextCommand()
        }
    }

    func clearCommandQueue() {
        priorityQueue.clear()
    }

    // MARK: - Private

    /// Setup data for new connection
    private func resetConnectionVariables() {

    }

    /// Execure new command from the queue
    private func executeNextCommand() {
        guard let peripheral = connectedPeripheral else {
            Log.w("Pump has not connected")
            return
        }

        guard executingCommand == nil else {
            Log.d("Connection manager has command in progress")
            return
        }

        guard let newCommand = priorityQueue.pop() else {
            Log.d("There is not command on queue")
            return
        }

        guard let cbCharacteristic = newCommand.characteristic.cbCharacteristic else {
            Log.w("Characteristic is nil. Invalid characteristic")
            return
        }

        executingCommand = newCommand
        switch newCommand.type {
        case .read:
            Log.d("Read characteristic: \(newCommand.characteristic.type)")
            peripheral.cbPeripheral.readValue(for: cbCharacteristic)
        case .write(let data):
            Log.d("Write characteristic: \(newCommand.characteristic.type), data: \(data.hexEncodedString())")
            peripheral.cbPeripheral.writeValue(data, for: cbCharacteristic, type: .withResponse)
        }
    }

    private func startSearchingPeripherals() {
        Log.i("")
        if centralManager.isScanning {
            centralManager.stopScan()
            Log.d("Stopped previous search")
        }

        if let cbuuids = cbuuidArray {
            centralManager.scanForPeripherals(withServices: cbuuids, options: [CBCentralManagerOptionShowPowerAlertKey: true])
            Log.d("Scan starter")
        }
    }

    private func containUnsubscribedCharacteristic(_ services: [Service]) -> Bool {
        return services.contains { service in
            return service.characteristics.contains(where: { return $0.notify == nil })
        }
    }

    private func containUndiscoveredCharacteristic(_ services: [Service]) -> Bool {
        return services.contains { service in
            return service.characteristics.contains(where: { return !$0.isDiscovered })
        }
    }

    private func readPumpVersion(_ handler: ((_ result: Result<PumpVersion, Error>) -> Void)?) {
        Log.d("")
        guard let characteristic = characteristic(withType: .pumpVersionCode, services: services) else {
            Log.w("Pump version characteristic not found")
            return
        }

        let command = PriorityCommand(type: .read,
                                      priority: characteristic.type.priority,
                                      characteristic: characteristic,
                                      handler: { result in
                                        switch result {
                                        case .success(let data):
                                            guard let data = data else {
                                                Log.e("Read data is nil")
                                                handler?(.failure(NDBluetoothError.readDataIsNil))
                                                return
                                            }
                                            let jsonString = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\0", with: "")
                                            let jsonData = jsonString.data(using: .utf8)!
                                            do {
                                                let pumpVersion = try JSONDecoder().decode(PumpVersion.self, from: jsonData)
                                                Log.d("Pump version has read: \(pumpVersion)")
                                                DispatchQueue.main.async { [weak self] in
                                                    self?.delegate?.pumpVersion(pumpVersion)
                                                }
                                                handler?(.success(pumpVersion))
                                            } catch let error {
                                                Log.e(jsonString)
                                                Log.e("encoding error: \(error.localizedDescription), code: \(error.code), domain: \(error.domain)")
                                                handler?(.failure(error))
                                            }

                                        case .failure(let error):
                                            Log.e("Error: \(error.localizedDescription), code: \(error.code), domain: \(error.domain)")
                                            handler?(.failure(error))
                                        }
                                      })
        priorityQueue.push(command)
        executeNextCommand()
    }

    private func selectPump(_ handler: ((_ result: Result<Bool, Error>) -> Void)?) {
        Log.d("")
        guard let characteristic = characteristic(withType: .selectPump, services: services) else {
            Log.w("Select pump characteristic not found")
            return
        }
        let selectBytes: [UInt8] = [0x01]
        let command = PriorityCommand(type: .write(Data(selectBytes)),
                                      priority: characteristic.type.priority,
                                      characteristic: characteristic,
                                      handler: { result in
                                        switch result {
                                        case .success:
                                            Log.d("Pump selected")
                                            handler?(.success(true))
                                        case .failure(let error):
                                            Log.e("Error: \(error.localizedDescription), code: \(error.code), domain: \(error.domain)")
                                            handler?(.failure(error))
                                        }
                                      })
        priorityQueue.push(command)
        executeNextCommand()
    }

    private func writeAuthCode(_ authCode: Data, _ handler: ((_ result: Result<Bool, Error>) -> Void)?) {
        Log.d("")
        guard let characteristic = characteristic(withType: .startAuthentication, services: services) else {
            Log.w("Select pump characteristic not found")
            return
        }
        let command = PriorityCommand(type: .write(authCode),
                                      priority: characteristic.type.priority,
                                      characteristic: characteristic,
                                      handler: { result in
                                        switch result {
                                        case .success:
                                            Log.d("Auth has written")
                                            handler?(.success(true))
                                        case .failure(let error):
                                            Log.e("Error: \(error.localizedDescription), code: \(error.code), domain: \(error.domain)")
                                            handler?(.failure(error))
                                        }
                                      })
        priorityQueue.push(command)
        executeNextCommand()
    }

    private func readPumpVersionAndExchangeAuthKey() {
        Log.d("")
        guard let authData = authorizationData else {
            // TODO: Return errror
            return
        }
        readPumpVersion { result in
            switch result {
            case .success:
                guard self.authorizationEnabled else {
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.connectionSuccess()
                    }
                    return
                }

                self.writeAuthCode(authData) { verificationResult in
                    switch verificationResult {
                    case .success:
                        self.state = .initialized
                        DispatchQueue.main.async { [weak self] in
                            self?.delegate?.connectionSuccess()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async { [weak self] in
                            self?.delegate?.connectionFailed(error: error)
                        }
                    }
                }
            case .failure(let error):
                self.resetConnectionVariables()
                self.state = .disconnected
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.connectionFailed(error: error)
                }
            }
        }
    }

    private func exchangeDataBeforePairing() {
        Log.d("")
        readPumpVersion { result in
            switch result {
            case .success:
                // TODO: - Save pump version and select pump
                self.selectPump { selectPumpResult in
                    switch selectPumpResult {
                    case .success:
                        if self.authorizationEnabled {
                            self.writeAuthCode(self.defaultAuthorizationData) { authCodeResult in
                                switch authCodeResult {
                                case .success:
                                    self.subscribeForNotifications()
                                case .failure(let error):
                                self.resetConnectionVariables()
                                self.state = .disconnectedWithError
                                DispatchQueue.main.async { [weak self] in
                                    self?.delegate?.connectionFailed(error: error)
                                }
                                }
                            }
                        } else {
                            self.subscribeForNotifications()
                        }
                    case .failure(let error):
                        self.resetConnectionVariables()
                        self.state = .disconnectedWithError
                        DispatchQueue.main.async { [weak self] in
                            self?.delegate?.connectionFailed(error: error)
                        }
                    }
                }
            case .failure(let error):
                self.resetConnectionVariables()
                self.state = .disconnected
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.connectionFailed(error: error)
                }
            }
        }
    }

    private func discoverAllServicesAndCharacteristics() {
        Log.d("")
        // Crete services array
        var servicesContainer: [Service] = []
        for serviceType in ServiceType.allCases where serviceType != .genericAttributeProfile {
            var characteristics: [Characteristic] = []
            for characteristicType in CharacteristicType.characteristics(forServiceType: serviceType) {
                let newCharacteristic = Characteristic(type: characteristicType)
                characteristics.append(newCharacteristic)
            }
            let newService = Service(type: serviceType, characteristics: characteristics)
            servicesContainer.append(newService)
        }

        self.services = servicesContainer

        let servicesUUIDs: [CBUUID] = services.map { CBUUID(string: $0.type.rawValue) }
        connectedPeripheral?.cbPeripheral.discoverServices(servicesUUIDs)
    }

    private func subscribeForNotifications() {
        Log.d("")
        let characteristics = services.flatMap { $0.characteristics }
        for characteristic in characteristics {
            guard let cbCharacteristic = characteristic.cbCharacteristic else {
                continue
            }

            if cbCharacteristic.properties.contains([.notify]) {
                Log.d("Characteristic supports notification. Start subscribing")
                connectedPeripheral?.cbPeripheral.setNotifyValue(true, for: cbCharacteristic)
            } else {
                Log.d("Characteristic does not support notification.")
                characteristic.setNotify(false)
            }
        }
    }

    private func characteristic(withType type: CharacteristicType, services: [Service]) -> Characteristic? {
        return services.flatMap { $0.characteristics }.first(where: { $0.type == type })
    }
}

// MARK: - CBCentralManagerDelegate

extension ConnectionManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        Log.d("state: \(central.state.rawValue)")
        switch central.state {
        case .poweredOn:
            if state == .disconnected || state == .disconnectedWithError, searchingForDevices {
                startSearchingPeripherals()
            }
        default:
            break
        }

        DispatchQueue.main.async {
            self.stateUpdatedHandler?(central.state)
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        guard let connectable = advertisementData[CBAdvertisementDataIsConnectable] as? Bool,
              let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String,
              connectable else {
            Log.d("discovered device: \(String(describing: advertisementData[CBAdvertisementDataLocalNameKey])) is not connectable")
            return
        }

        guard !discoveredPeripherals.contains(where: { $0.cbPeripheral.name == peripheral.name }) else {
            Log.d("Device exists in discoveredPeripherals list")
            return
        }

        Log.d("New peripheral found: \(localName)")

        discoveredPeripherals.append(Peripheral(name: localName, peripheral: peripheral))
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.delegate?.peripheralListUpdated(self.discoveredPeripherals)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        Log.i("Peripheral \(peripheral.name ?? "") identifier: \(peripheral.identifier) connected")
        connectedPeripheral = connectablePeripheral
        peripheral.delegate = self
        state = .connected
        connectedPumpName = peripheral.name
        discoverAllServicesAndCharacteristics()
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        Log.w("Peripheral: \(peripheral.name ?? "NoName"), error: \(String(describing: error?.localizedDescription))")
        connectablePeripheral = nil
        connectedPeripheral = nil
        services = []
        state = .disconnected
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.connectionFailed(error: error)
        }
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        Log.i("")
        // If connection is not initialized call `connectionFailed` insted of `didDisconnectPeripheral`
        if state == .connecting || state == .connected {
            // Change state to disconnected
            Log.d("Return connnection failed")
            state = .disconnected
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.connectionFailed(error: self?.pumpInitError ?? error)
            }
            return
        }

        Log.i("1")

        // If error exists change state to `disconnectedWithError` (This is important for retry last command)
        if error != nil {
            state = .disconnectedWithError
        } else {
            state = .disconnected
        }

        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didDisconnectPeripheral(peripheral, error: error)
        }
    }
}

// MARK: - CBPeripheralDelegate

extension ConnectionManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        Log.i("Called")
        if let error = error {
            Log.e("Error: \(error.localizedDescription), code: \(error.code), domain: \(error.domain)")
            pumpInitError = error
            disconnectThePump()
            return
        }

        guard let services = peripheral.services else {
            Log.e("Peripheral does not have services")
            disconnectThePump()
            return
        }

        for cbService in services {
            guard let service = self.services.first(where: { $0.type.rawValue.uppercased() == cbService.uuid.uuidString.uppercased() }) else {
                Log.e("Discovered service \(cbService) is not in discovery list")
                continue
            }

            service.setCbService(cbService)
            let characteristics: [CBUUID] =  service.characteristics.map { CBUUID(string: $0.type.rawValue) }
            peripheral.discoverCharacteristics(characteristics, for: cbService)
        }
        Log.v("All services discovered")
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // Error occurred
        guard error == nil else {
            Log.e("service: \(service), error: \(error!.localizedDescription), code: \(error!.code), domain: \(error!.domain)")
            // Have all characteristics discovered
            return
        }

        Log.i("service \(service) discovered")

        guard let characteristics = service.characteristics else {
            Log.w("Service \(service) does not characteristics")
            return
        }

        guard let service = services.first(where: { $0.type.rawValue.uppercased() == service.uuid.uuidString.uppercased() }) else {
            Log.w("Service \(service) does not exis in service list")
            // Mark as discovered
            return
        }

        for cbCharacteristic in characteristics {
            if let characteristic = service.characteristics.first(where: { $0.type.rawValue.uppercased() == cbCharacteristic.uuid.uuidString.uppercased() }) {
                Log.d("Characteristic found in services list")
                characteristic.setCbCharacteeristic(cbCharacteristic)
            }
        }

        if !containUndiscoveredCharacteristic(services) {
            if isFirstTimeConnect {
                exchangeDataBeforePairing()
            } else {
                subscribeForNotifications()
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            Log.w("Characteristic: \(characteristic) error: \(error.localizedDescription), code: \(error.code), domain: \(error.domain)")
            if error.code == CBATTError.Code.insufficientAuthentication.rawValue {
                pumpInitError = error
                disconnectThePump()
            }
        } else {
            Log.i("characteristic: \(characteristic)")
        }

        let characteristicObject = services.flatMap { $0.characteristics }
            .first(where: { $0.type.rawValue.uppercased() == characteristic.uuid.uuidString.uppercased() })
        characteristicObject?.setNotify(characteristic.isNotifying)

        if !containUnsubscribedCharacteristic(services) {
            if isFirstTimeConnect {
                if !authorizationEnabled {
                    state = .initialized
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.connectionSuccess()
                    }
                }
            } else {
                readPumpVersionAndExchangeAuthKey()
            }
            Log.d("All notification subscribed")
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // Handle executong command
        if let command = executingCommand, command.characteristic.cbCharacteristic?.uuid.uuidString.uppercased() == characteristic.uuid.uuidString.uppercased() {
            if let error = error {
                Log.e("error: \(error.localizedDescription), code: \(error.code), domain: \(error.domain)")
                DispatchQueue.main.async {
                    command.handler?(.failure(error))
                }
            } else {
                Log.i("commandExecuted: \(characteristic.uuid.uuidString), value: \(String(describing: characteristic.value))")
                DispatchQueue.main.async {
                    command.handler?(.success(characteristic.value))
                }
            }
            executingCommand = nil
            executeNextCommand()
            return
        }

        // Handle received notification
        Log.i("notification arrived: \(characteristic.uuid.uuidString.uppercased()), value: \(String(describing: characteristic.value))")
        switch characteristic.uuid.uuidString {
        case CharacteristicType.startAuthentication.rawValue.uppercased():
            state = .initialized
            DispatchQueue.main.async { [weak self] in
                if let data = characteristic.value {
                    self?.delegate?.authorizaionKey(data)
                }
                self?.delegate?.connectionSuccess()
            }
            return
        default:
            break
        }
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didUpdateValue(forCharacteristic: characteristic, error: error)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        Log.i("characteristic: \(characteristic), error: \(String(describing: error))")
        guard let command = executingCommand else {
            Log.w("executing command is nil")
            return
        }

        guard command.characteristic.cbCharacteristic?.uuid.uuidString.uppercased() == characteristic.uuid.uuidString.uppercased() else {
            Log.w("Written characteristic is not same as executing command")
            return
        }

        if let error = error {
            Log.e("error: \(error.localizedDescription), code: \(error.code), domain: \(error.domain)")
            DispatchQueue.main.async {
                command.handler?(.failure(error))
            }
        } else {
            Log.d("Data has written")
            DispatchQueue.main.async {
                command.handler?(.success(nil))
            }
        }

        executingCommand = nil
        executeNextCommand()
    }
}
