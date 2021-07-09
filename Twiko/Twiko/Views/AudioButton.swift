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

    // MARK: - Data

    private let type: AlarmPriority
    private var isButtonEnabled = true

    // MARK: - Initialization

    init(type: AlarmPriority) {
        self.type = type
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        self.type = .high
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

        switch type {
        case .high:
            audioImageView.image = Asset.Images.highPriorityAudio.image.withRenderingMode(.alwaysTemplate)
            setupAudioButton(color: Asset.Colors.alertColorHigh.color, title: NSLocalizedString("Pause audio", comment: "").uppercased())
        case .medium:
            audioImageView.image = Asset.Images.defaultAudio.image.withRenderingMode(.alwaysTemplate)
            setupAudioButton(color: Asset.Colors.alertColorMedium.color, title: NSLocalizedString("Turn off audio", comment: "").uppercased())
        default:
            audioImageView.image = Asset.Images.defaultAudio.image.withRenderingMode(.alwaysTemplate)
            setupAudioButton(color: Asset.Colors.alertColorLow.color, title: NSLocalizedString("Turn off audio", comment: "").uppercased())

        }
    }

    override var isEnabled: Bool {
        get {
            return isButtonEnabled
        }
        set {
            isButtonEnabled = newValue
            switch type {
            case .high:
                let color = newValue ? Asset.Colors.alertColorHigh.color : Asset.Colors.neutralColorDark.color
                let title = newValue ? NSLocalizedString("Pause audio", comment: "").uppercased() : NSLocalizedString("Audio paused", comment: "").uppercased()
                setupAudioButton(color: color, title: title)
                backgroundColor = newValue ? .white : Asset.Colors.neutralColorLight.color
            case .medium:
                let color = newValue ? Asset.Colors.alertColorMedium.color : Asset.Colors.neutralColorDark.color
                let title = newValue ? NSLocalizedString("Turn off audio", comment: "").uppercased() : NSLocalizedString("Audio off", comment: "").uppercased()
                setupAudioButton(color: color, title: title)
                backgroundColor = newValue ? .white : Asset.Colors.neutralColorLight.color
            default:
                let color = newValue ? Asset.Colors.alertColorLow.color : Asset.Colors.neutralColorDark.color
                let title = newValue ? NSLocalizedString("Turn off audio", comment: "").uppercased() : NSLocalizedString("Audio off", comment: "").uppercased()
                setupAudioButton(color: color, title: title)
                backgroundColor = newValue ? .white : Asset.Colors.neutralColorLight.color
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        let height: CGFloat = 50
        return CGSize(width: super.intrinsicContentSize.width, height: height)
    }

    // MARK: - Helpers

    func setupAudioButton(color: UIColor, title: String) {
        setAttributedTitle(title.uppercased().getAttributedStringWithSpacing(spacing: 1.37), for: .normal)
        layer.borderColor = color.cgColor
        audioImageView.tintColor = color
        setTitleColor(color, for: .normal)
    }
}
