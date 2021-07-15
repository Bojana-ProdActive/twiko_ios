////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// Button.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        24.5.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////
final class Button: BaseButton {

    // MARK: - Enums

    enum ButtonType {
        case primary
        case secondary
    }

    // MARK: - Data

    private let type: ButtonType
    private var titleText: String = ""

    private var inset: CGFloat = {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 70
        default:
            return 10
        }
    }()

    // MARK: - Initialization

    init(type: ButtonType, titleText: String? = "") {
        self.type = type
        self.titleText = titleText ?? ""
        super.init(frame: .zero)
        commonInit()
    }

    override init(frame: CGRect) {
        type = .primary
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        type = .primary
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        clipsToBounds = true

        setAppearanceByType()
    }

    private func setAppearanceByType() {
        titleLabel?.font = UIFont.secondary(size: UIDevice.current.userInterfaceIdiom == .pad ? 26 : 16, weight: .semibold)
        switch type {
        case .primary:
            backgroundColor = Asset.Colors.secondaryColor.color
            let attributedButtonTitle = titleText.uppercased().getAttributedStringWithSpacing(spacing: 0.43)
            setAttributedTitle(attributedButtonTitle, for: .normal)
            setTitleColor(.black, for: .normal)
            layer.cornerRadius = 8
            titleEdgeInsets = UIEdgeInsets(top: 0.0, left: inset, bottom: 0.0, right: inset)
        case .secondary:
            backgroundColor = .white
            let attributedButtonTitle = titleText.uppercased().getAttributedStringWithSpacing(spacing: 0.37)
            setAttributedTitle(attributedButtonTitle, for: .normal)
            titleLabel?.font = UIFont.secondary(size: 22, weight: .semibold)
            setTitleColor(.black, for: .normal)
            layer.cornerRadius = 8
            layer.borderWidth = 1.5
            layer.borderColor = Asset.Colors.secondaryColor.color.cgColor
            layer.masksToBounds = true
            titleEdgeInsets = UIEdgeInsets(top: 0.0, left: inset, bottom: 0.0, right: inset)
        }
    }

    // MARK: - UIButton

    override var isEnabled: Bool {
        get {
            return true
        }
        set {
            switch type {
            case .primary:
                backgroundColor = newValue ? Asset.Colors.primaryColor.color : Asset.Colors.neutralColorLight.color
                setTitleColor(newValue ? .black : Asset.Colors.neutralColorDark.color, for: .normal)
            default:
                alpha = 0.5
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        var height: CGFloat = 40

        switch type {
        case .primary:
            height = UIDevice.current.userInterfaceIdiom == .pad ? 70 : 50
        case .secondary:
            height = UIDevice.current.userInterfaceIdiom == .pad ? 70 : 50
        }
        return CGSize(width: super.intrinsicContentSize.width + 2 * inset, height: height)
    }
}
