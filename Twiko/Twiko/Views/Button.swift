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
final class Button: UIButton {

    // MARK: - Enums

    enum ButtonType {
        case primary
    }

    // MARK: - Data

    private let type: ButtonType

    // MARK: - Initialization

    init(type: ButtonType) {
        self.type = type
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
        switch type {
        case .primary:
            backgroundColor = Asset.Colors.accentColor.color
        }
    }

    // MARK: - UIButton

    override var isHighlighted: Bool {
        didSet {
            if isEnabled {
                self.alpha = isHighlighted ? 0.5 : 1.0
            } else {
                self.alpha = 0.0
            }
        }
    }

    override var isEnabled: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                if self.isEnabled {
                    self.alpha = 1.0
                } else {
                    self.alpha = 0.5
                }
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        var height: CGFloat = 40

        switch type {
        case .primary:
            height = 50
        }
        return CGSize(width: super.intrinsicContentSize.width, height: height)
    }
}
