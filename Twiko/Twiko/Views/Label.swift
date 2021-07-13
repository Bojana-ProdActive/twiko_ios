////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// Label.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        24.5.21.
//
////////////////////////////////////////////////////////////////////////////////
import NDBluetoothLibrary
import UIKit
////////////////////////////////////////////////////////////////////////////////
final class Label: UILabel {

    enum LabelType {
        case title                      // Top titles on the FTU and other screens (for example: 'Please select your language' FTU/Language Screen)
        case selecting                  // Text of possible options (for example: 'English - US' FTU/Language screen)
        case description                // Right side description (for example: 'Set up the dosing regimen.' FTU/Regiment screen)
        case info                       // Shows user info after actions (example: "Weel done!")
        case explanation

        case imageDescription           // Under the filing flow images

        case status
        case statusDescription

        case alarmTitle
        case alarmDescription
        case alertInfo
        case notificationTitle
        case notificationDescription
    }

    // MARK: - Data

    let type: LabelType
    private var labelText: String?

    // MARK: - Override

    override var text: String? {
        didSet {
            labelText = text
            var spacing: CGFloat = 0
            switch type {
            case .alarmTitle:
                spacing = 0.45
            case .alarmDescription:
                spacing = 0.37
            case .alertInfo:
                  spacing = 0.38
            case .notificationTitle:
                spacing = 0.43
            case .notificationDescription:
                spacing = 0.58
            default:
                spacing = 0.45
            }
            attributedText = labelText?.getAttributedStringWithSpacing(spacing: spacing)
        }
    }

    // MARK: - Initialization

    init(type: LabelType) {
        self.type = type
        super.init(frame: .zero)
        commonInit()
    }

    override init(frame: CGRect) {
        type = .alarmTitle
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        type = .alarmTitle
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        textAlignment = .center

        setAppearanceByType()
    }

    // swiftlint:disable cyclomatic_complexity
    private func setAppearanceByType() {
        switch type {
        case .title:
            numberOfLines = 1
            textColor = .black
            font = UIFont.primary(size: 34, weight: .bold)
        case .description:
            textColor = .white
            font = FontFamily.BarlowSemiCondensed.semiBoldItalic.font(size: 30)
            textAlignment = .natural
        case .selecting:
            numberOfLines = 1
            textColor = .black
            font = UIFont.primary(size: 28, weight: .semibold)
        case .info:
            textColor = .black
            font = FontFamily.BarlowSemiCondensed.semiBoldItalic.font(size: 36)
            textAlignment = .natural
        case .status:
            textColor = .black
        case .statusDescription:
            textColor = .black
            font = FontFamily.Barlow.semiBold.font(size: 20)
        case .explanation:
            font = FontFamily.BarlowSemiCondensed.mediumItalic.font(size: 21)
            textColor = .black
            textAlignment = .natural
        case .imageDescription:
            font = FontFamily.BarlowSemiCondensed.mediumItalic.font(size: 28)
            textColor = .black
        case .alarmTitle:
            numberOfLines = 1
            font = UIFont.secondary(size: 34, weight: .semibold)
            textAlignment = .natural
        case .alarmDescription:
            font = FontFamily.BarlowSemiCondensed.mediumItalic.font(size: 30)
            textAlignment = .natural
            textColor = .black
        case .alertInfo:
            font = FontFamily.Barlow.medium.font(size: 20)
            numberOfLines = 1
            textColor = Asset.Colors.neutralColorDark.color
            textAlignment = .natural
        case .notificationTitle:
            font = FontFamily.BarlowSemiCondensed.semiBoldItalic.font(size: 32)
            textColor = .black
            textAlignment = .natural
        case .notificationDescription:
            font = FontFamily.BarlowSemiCondensed.medium.font(size: 26)
            textColor = .black
            textAlignment = .natural
        }
    }
    // swiftlint:enable cyclomatic_complexity
}
