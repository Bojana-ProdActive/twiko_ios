//
//  ViewController.swift
//  Twiko
//
//  Created by Goran Tokovic on 19.5.21..
//

import NDBluetoothLibrary
import UIKit

class ViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellClass(UITableViewCell.self)
        return tableView
    }()

    private lazy var scanButton: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Scan", style: .plain, target: self, action: #selector(scanButtonTapper))
        return item
    }()

    private lazy var commandButton: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Turn Off", style: .plain, target: self, action: #selector(commandButtonTapped))
        return item
    }()

    private var devices: [Peripheral] = []
    private var isScanning: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.pinToSafeArea(ofView: view)

        navigationItem.rightBarButtonItem = scanButton
        PumpManager.shared.delegate = self
    }

    @objc  private func scanButtonTapper() {
        if isScanning {
            scanButton.title = "Scan"
            PumpManager.shared.stopSearchingPumps()

        } else {
            scanButton.title = "Stop scan"
            searchForPumps()
        }
        isScanning.toggle()
    }

    @objc private func commandButtonTapped() {
//        PumpManager.shared.disconnect()
        PumpManager.shared.sendTurnOffCommand { result in
            switch result {
            case .success:
                debugPrint("***** Pump command sent *****")
            case .failure(let error):
                debugPrint("***** Pump command error: \(error) *****")
            }
        }
    }

    private func searchForPumps() {
        PumpManager.shared.scanForConnectablePumps()
    }

    private func connect(peripheral: Peripheral) {
        PumpManager.shared.connect(peripheral)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(atIndexPath: indexPath)
        cell.textLabel?.text = devices[indexPath.row].localName
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        PumpManager.shared.stopSearchingPumps()
        scanButton.title = "Scan"
        scanButton.isEnabled = false
        connect(peripheral: devices[indexPath.row])
    }
}

extension ViewController: PumpManagerDelegate {

    func didPumpStatusRegisterChanged(_ pump: Pump) {
        // TODO:
    }

    func didPumpAlarmChanged(_ pump: Pump) {
        // TODO:
    }

    func peripheralsListUpdated(_ peripherals: [Peripheral]) {
        devices = peripherals
        tableView.reloadData()
    }

    func didConnectPump() {
        debugPrint("***** Pump connected *****")
        navigationItem.rightBarButtonItem = commandButton
    }

    func didFailToConnect(_ error: Error?) {
        debugPrint("***** Connection has not established *****")
        scanButton.isEnabled = true
        navigationItem.rightBarButtonItem = scanButton
    }

    func didDisconnectPump(_ error: Error?) {
        debugPrint("***** Pump has disconnected *****")
        scanButton.isEnabled = true
        navigationItem.rightBarButtonItem = scanButton
    }
}
