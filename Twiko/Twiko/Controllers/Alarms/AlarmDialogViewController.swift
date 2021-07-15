////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// AlarmDialogViewController.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        13.7.21.
//
////////////////////////////////////////////////////////////////////////////////
import NDBluetoothLibrary
import UIKit
////////////////////////////////////////////////////////////////////////////////
final class AlarmDialogViewController: UIViewController {

    // MARK: - UI components

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()

    private lazy var okButton: Button = {
        let button = Button(type: .primary, titleText: "Ok")
        return button
    }()

    private lazy var prepareTreatmentButton: Button = {
        let button = Button(type: .primary, titleText: "Prepare treatment")
        return button
    }()

    private lazy var closeButton: Button = {
        let button = Button(type: .primary, titleText: "Close")
        return button
    }()

    private lazy var audioButton: AudioButton = {
        let button = AudioButton(70)
        return button
    }()

    private lazy var resumeProcesButton: Button = {
        let button = Button(type: .primary, titleText: "Resume process")
        return button
    }()

    private lazy var alarmDialogView = AlarmDialogView(type: connectionType, alarm: alarm)
    private lazy var positiveButton = UIButton()
    private lazy var negateiveButton = UIButton()

    // MARK: - Data

    private var alarm: PumpAlarm!
    private var connectionType: ConnectionType = .broadcast

    private var viewModel: AlarmDialogViewModelProtocol = AlarmDialogViewModel()

    // MARK: - Initialization

    init(alarm: PumpAlarm, connectionType: ConnectionType, viewModel: AlarmDialogViewModel? = AlarmDialogViewModel()) {
        self.alarm = alarm
        self.viewModel = viewModel ?? AlarmDialogViewModel()
        self.connectionType = connectionType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Life cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)

        setupDialogActions()
        setupConstraints()
    }

    private func setupConstraints() {
        positiveButton.translatesAutoresizingMaskIntoConstraints = false
        negateiveButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: Dimensions.dialogViewHeight),
            containerView.widthAnchor.constraint(equalToConstant: Dimensions.dialogViewWidth)
        ])

        containerView.addSubview(alarmDialogView)
        NSLayoutConstraint.activate([
            alarmDialogView.topAnchor.constraint(equalTo: containerView.topAnchor),
            alarmDialogView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        ])
        containerView.layer.masksToBounds = true

        view.addSubview(positiveButton)
        NSLayoutConstraint.activate([
            positiveButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
            positiveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -25)
        ])

        view.addSubview(negateiveButton)
        NSLayoutConstraint.activate([
            negateiveButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            negateiveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -25)
        ])

    }

    // MARK: - Actions

    // MARK: - Helpers

    private func setupDialogActions() {
        guard let alarmCode = alarm.alarmCode, let alarm = AlarmType(rawValue: alarmCode) else {
            return
        }

        let actions = viewModel.getActionsForAlarmDialog(alarm, connectionType)

        for i in actions {
            switch i {
            case .ok:
                positiveButton = okButton
            case .prepareTreatment:
                positiveButton = prepareTreatmentButton
            case .resumeProces:
                positiveButton = resumeProcesButton
            case .close:
                negateiveButton = closeButton
            case .audio:
                audioButton.setupAudioButtonForAlarmPriority(alarmPriority: alarm.getAlertPriority())
                if actions.count == 1 {
                    positiveButton = audioButton
                } else {
                    negateiveButton = audioButton
                }
            }
        }
        reloadInputViews()
    }

}
