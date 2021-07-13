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
        titleLabel?.font = UIFont.primary(size: 26, weight: .semibold)
        switch type {
        case .primary:
            backgroundColor = Asset.Colors.secondaryColor.color

            setAttributedTitle(titleText.uppercased().getAttributedStringWithSpacing(spacing: 1.43), for: .normal)
            setTitleColor(.black, for: .normal)
            layer.cornerRadius = 3
            titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        case .secondary:
            backgroundColor = .white

            setAttributedTitle(titleText.uppercased().getAttributedStringWithSpacing(spacing: 1.37), for: .normal)
            setTitleColor(.black, for: .normal)
            layer.cornerRadius = 3
            layer.borderWidth = 1.5
            layer.borderColor = Asset.Colors.secondaryColor.color.cgColor
            layer.masksToBounds = true
            titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
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
            height = 70
        case .secondary:
            height = 70
        }
        return CGSize(width: super.intrinsicContentSize.width + 40, height: height)
    }
}
