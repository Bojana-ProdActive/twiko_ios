////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// BaseAlarmView.swift
//
// AUTHOR IDENTITY:
//        Bojana Vojvodic        9.7.21.
//
////////////////////////////////////////////////////////////////////////////////
import NDBluetoothLibrary
import UIKit
////////////////////////////////////////////////////////////////////////////////
class AlarmView: UIView {

    // MARK: - UI components

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel = Label(type: .alarmTitle)
    private lazy var descriptionLabel = Label(type: .alarmDescription)
    private lazy var infoLabel = Label(type: .alertInfo)
    private lazy var audioButton = AudioButton()

    // MARK: - UI data

    private var offset: CGFloat = 30

    private var viewHeight: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 320
        default:
            return 250
        }
    }

    private var viewWidth: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 944
        default:
            return 650
        }
    }

    // MARK: - Data

    private var connectionType: ConnectionType = .broadcast
    private var alarm: PumpAlarm?

    // MARK: - Initialization

    init(type: ConnectionType, alarm: PumpAlarm) {
        self.connectionType = type
        self.alarm = alarm
        super.init(frame: .zero)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 15

        layer.shadowColor = Asset.Colors.neutralColorDark.color.cgColor
        layer.shadowOpacity = 2
        layer.shadowOffset = .zero
        layer.shadowRadius = 15

        guard let alarm = alarm, let alarmCode = alarm.alarmCode, let alarmType = AlarmType(rawValue: alarmCode) else {
            return
        }

        titleLabel.text = AlertHelper.alertTitle(alarmType).uppercased()
        titleLabel.textColor = AlertHelper.titleColorOfAlert(alarmType)
        imageView.backgroundColor = AlertHelper.colorForAlert(alarmType)

        if let image = AlertHelper.iconForAlert(alarmType).imageWithInsets(insets: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)) {
            imageView.image = image.withRenderingMode(.alwaysTemplate)
        }
        descriptionLabel.text = AlertHelper.alertDescription(alarmType)
        audioButton.setupAudioButtonForAlarmPriority(alarmPriority: alarmType.getAlertPriority())
        reloadInputViews()
        audioButton.isEnabled = alarm.isSoundEnabled

        audioButton.isHidden = connectionType == .broadcast

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: viewHeight),
            widthAnchor.constraint(equalToConstant: viewWidth)
        ])

        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.32)
        ])

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: offset),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: offset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset)
        ])

        addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset),
            infoLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: offset),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset)
        ])

        addSubview(audioButton)
        NSLayoutConstraint.activate([
            audioButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset),
            audioButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset)
        ])

        addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: offset),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: audioButton.topAnchor, constant: -offset)
        ])
    }
}
