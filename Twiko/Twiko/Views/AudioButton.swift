////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// AudioButton.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        6.7.21.
//
////////////////////////////////////////////////////////////////////////////////
import NDBluetoothLibrary
import UIKit
////////////////////////////////////////////////////////////////////////////////
final class AudioButton: UIButton {

    // MARK: - UIComponents

    private lazy var audioImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var buttonTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    // MARK: - Data

    private var alarmPriority: AlarmPriority?
    private var isButtonEnabled = true

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 3
        layer.borderWidth = 1.5
        layer.masksToBounds = true

        addSubview(audioImageView)
        NSLayoutConstraint.activate([
            audioImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            audioImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            audioImageView.heightAnchor.constraint(equalToConstant: 35),
            audioImageView.widthAnchor.constraint(equalToConstant: 31)
        ])

        addSubview(buttonTitleLabel)
        NSLayoutConstraint.activate([
            buttonTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            buttonTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            buttonTitleLabel.trailingAnchor.constraint(equalTo: audioImageView.leadingAnchor, constant: -10)
        ])
    }

    override var isEnabled: Bool {
        didSet {
            guard let alarmPriority = alarmPriority else {
                return
            }
            switch alarmPriority {
            case .high:
                let color = isEnabled ? Asset.Colors.alertColorHigh.color : Asset.Colors.neutralColorDark.color
                let title = isEnabled ? NSLocalizedString("Pause audio", comment: "").uppercased() : NSLocalizedString("Audio paused", comment: "").uppercased()
                setupButtonDetails(color: color, title: title)
                backgroundColor = isEnabled ? .white : Asset.Colors.neutralColorLight.color
            case .medium:
                let color = isEnabled ? Asset.Colors.alertColorMedium.color : Asset.Colors.neutralColorDark.color
                let title = isEnabled ? NSLocalizedString("Turn off audio", comment: "").uppercased() : NSLocalizedString("Audio off", comment: "").uppercased()
                setupButtonDetails(color: color, title: title)
                backgroundColor = isEnabled ? .white : Asset.Colors.neutralColorLight.color
            default:
                let color = isEnabled ? Asset.Colors.alertColorLow.color : Asset.Colors.neutralColorDark.color
                let title = isEnabled ? NSLocalizedString("Turn off audio", comment: "").uppercased() : NSLocalizedString("Audio off", comment: "").uppercased()
                setupButtonDetails(color: color, title: title)
                backgroundColor = isEnabled ? .white : Asset.Colors.neutralColorLight.color
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        let height: CGFloat = 50
        return CGSize(width: super.intrinsicContentSize.width, height: height)
    }

    // MARK: - Helpers

    private func setupButtonDetails(color: UIColor, title: String) {
        let attributedButtonTitle = title.uppercased().getAttributedStringWithSpacing(spacing: 1.37)
        buttonTitleLabel.attributedText = attributedButtonTitle
        layer.borderColor = color.cgColor
        audioImageView.tintColor = color
        buttonTitleLabel.textColor = color
    }

    // MARK: - Public

    func setupAudioButtonForAlarmPriority(alarmPriority: AlarmPriority) {
        self.alarmPriority = alarmPriority
        switch alarmPriority {
        case .high:
            audioImageView.image = Asset.Images.highPriorityAudio.image.withRenderingMode(.alwaysTemplate)
            setupButtonDetails(color: Asset.Colors.alertColorHigh.color, title: NSLocalizedString("Pause audio", comment: "").uppercased())
        case .medium:
            audioImageView.image = Asset.Images.defaultAudio.image.withRenderingMode(.alwaysTemplate)
            setupButtonDetails(color: Asset.Colors.alertColorMedium.color, title: NSLocalizedString("Turn off audio", comment: "").uppercased())
        default:
            audioImageView.image = Asset.Images.defaultAudio.image.withRenderingMode(.alwaysTemplate)
            setupButtonDetails(color: Asset.Colors.alertColorLow.color, title: NSLocalizedString("Turn off audio", comment: "").uppercased())

        }

    }
}
