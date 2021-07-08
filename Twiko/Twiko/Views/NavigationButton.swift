////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// NavigationButton.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        7.7.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////
final class NavigationButton: BaseButton {

    enum ButtonType {
        case back
        case menu
    }

    // MARK: - UI components

    // MARK: - Data

    var type: ButtonType = .back {
        didSet {
            setAppearanceByType()
        }
    }

    // MARK: - Initialization

    init(buttonType: ButtonType) {
        type = buttonType
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

        setAppearanceByType()
    }

    private func setAppearanceByType() {
        hitEdgeInsets = UIEdgeInsets(value: -10)
        switch type {
        case .back:
            setImage(Asset.Images.Navigation.back.image, for: .normal)
        case .menu:
            setImage(Asset.Images.Navigation.menu.image, for: .normal)
        }
        imageView?.contentMode = .scaleAspectFit
    }

    override var intrinsicContentSize: CGSize {
        switch type {
        case .back, .menu:
            return CGSize(width: 42, height: 42)
        }
    }
}
