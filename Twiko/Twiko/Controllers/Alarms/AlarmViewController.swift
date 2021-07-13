////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// AlarmViewController.swift
//
// AUTHOR IDENTITY:
//        Bojana Vojvodic        12.7.21.
//
////////////////////////////////////////////////////////////////////////////////
import NDBluetoothLibrary
import UIKit
////////////////////////////////////////////////////////////////////////////////
final class AlarmViewController: UIViewController {

    // MARK: - UI components

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var alarmView: AlarmView = AlarmView(type: connectionType, alarm: alarm)

    // MARK: - Data

    private var alarm: PumpAlarm!
    private var connectionType: ConnectionType = .broadcast

    private var viewModel: AlarmViewModelProtocol = AlarmViewModel()

    // MARK: - Initialization

    init(alarm: PumpAlarm, connectionType: ConnectionType, viewModel: AlarmViewModelProtocol? = AlarmViewModel()) {
        self.alarm = alarm
        self.viewModel = viewModel ?? AlarmViewModel()
        self.connectionType = connectionType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Life cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupStackView()
    }

    private func setupConstraints() {
        view.addSubview(alarmView)
        NSLayoutConstraint.activate([
            alarmView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alarmView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: alarmView.bottomAnchor, constant: 40),
            stackView.heightAnchor.constraint(equalToConstant: 70),
            stackView.trailingAnchor.constraint(equalTo: alarmView.trailingAnchor)
        ])
    }

    // MARK: - Actions

    // MARK: - Helpers

    private func setupStackView() {
        guard let alarmCode = alarm.alarmCode, let alarm = AlarmType(rawValue: alarmCode) else {
            return
        }

        let actions = viewModel.getAlarmActions(alarm)
        for i in actions {
            switch i {
            case .prepareTreatment:
                let button = Button(type: .primary)
                button.setTitle(NSLocalizedString("Prepare treatment", comment: "").uppercased(), for: .normal)
                stackView.addArrangedSubview(button)
            case .videoTutorials:
                let button = Button(type: .primary)
                button.setTitle(NSLocalizedString("Video tutorials", comment: "").uppercased(), for: .normal)
                stackView.addArrangedSubview(button)
            default:
                let button = Button(type: .secondary)
                button.setTitle(NSLocalizedString("Pump status", comment: "").uppercased(), for: .normal)
                stackView.addArrangedSubview(button)
            }
        }
    }
}
