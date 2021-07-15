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

    private lazy var helpView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Asset.Colors.neutralColorDark.color.cgColor
        view.layer.shadowOpacity = 2
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 18
        view.layer.cornerRadius = 18
        view.backgroundColor = .white
        return view
    }()

    private lazy var alarmView = AlarmView()

    // MARK: - Data

    private var alarm: PumpAlarm?
    private var connectionType: ConnectionType = .broadcast

    private var viewModel: AlarmViewModelProtocol = AlarmViewModel()

    // MARK: - Initialization

    init(viewModel: AlarmViewModelProtocol? = AlarmViewModel()) {
        self.viewModel = viewModel ?? AlarmViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    init(alarm: PumpAlarm, connectionType: ConnectionType, viewModel: AlarmViewModelProtocol? = AlarmViewModel()) {
        self.alarm = alarm
        self.viewModel = viewModel ?? AlarmViewModel()
        self.connectionType = connectionType
        super.init(nibName: nil, bundle: nil)

        setupWithAlarm(alarm, connectionType)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Life cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
    }

    private func setupConstraints() {
        view.addSubview(helpView)
        NSLayoutConstraint.activate([
            helpView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            helpView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            helpView.widthAnchor.constraint(equalToConstant: Dimensions.alarmViewWidth),
            helpView.heightAnchor.constraint(equalToConstant: Dimensions.alarmViewHeight)
        ])

        view.addSubview(alarmView)
        NSLayoutConstraint.activate([
            alarmView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alarmView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: alarmView.bottomAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? 40 : 20),
            stackView.heightAnchor.constraint(equalToConstant: 70),
            stackView.trailingAnchor.constraint(equalTo: alarmView.trailingAnchor)
        ])
    }

    // MARK: - Actions

    // MARK: - Helpers

    func setupWithAlarm(_ alarm: PumpAlarm, _ connectionType: ConnectionType) {
        self.alarm = alarm
        self.connectionType = connectionType

        alarmView.setupAlarmData(alarm)
        alarmView.setupConnectionType(connectionType)

        stackView.arrangedSubviews
                    .filter({ $0 is Button })
                    .forEach({ $0.removeFromSuperview() })
        setupStackView()
    }

    private func setupStackView() {
        guard let alarm = alarm, let alarmCode = alarm.alarmCode, let alarm = AlarmType(rawValue: alarmCode) else {
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
                button.addTarget(self, action: #selector(test), for: .touchUpInside)
            }
        }
    }

    @objc func test() {
        setupWithAlarm(PumpAlarm(code: 2, detailsCode: 58, isSoundEnabled: false, noTreatmentDuration: 25, alarmDescription: ""), .connected)
    }
}
