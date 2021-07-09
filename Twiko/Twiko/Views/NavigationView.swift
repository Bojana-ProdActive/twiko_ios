////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// NavigationView.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        7.7.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////
final class NavigationView: UIView {

    enum NavigationButtonType {
        case none
        case back
        case menu
    }

    // MARK: - UI components

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView.newAutoLayoutView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 18
        return stackView
    }()

    private(set) lazy var rightNavigationButton: NavigationButton = NavigationButton(buttonType: .back)

    private lazy var titleLabel: UILabel = {
        #warning("Change with custom component")
        let label = UILabel.newAutoLayoutView()
        label.font = UIFont.secondary(size: 34, weight: .bold)
        label.text = "Lorem Ipsum"
        return label
    }()

    private lazy var bottomDividerView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = Asset.Colors.neutralColorDark.color
        return view
    }()

    // MARK: - Data

    var navigationButtonType: NavigationButtonType = .none {
        didSet {
            setAppearanceByType()
        }
    }

    // MARK: - Initialization

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

        // Stack view
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24)
        ])

        // Navigation button
        stackView.addArrangedSubview(rightNavigationButton)

        // Title label
        stackView.addArrangedSubview(titleLabel)

        // Bottom divider
        addSubview(bottomDividerView)
        NSLayoutConstraint.activate([
            bottomDividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomDividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomDividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomDividerView.heightAnchor.constraint(equalToConstant: 1)
        ])

        setAppearanceByType()
    }

    var title: String? {
        get {
            return titleLabel.text
        }

        set {
            titleLabel.text = newValue
        }
    }

    private func setAppearanceByType() {
        switch navigationButtonType {
        case .none:
            rightNavigationButton.isHidden = true
            rightNavigationButton.isEnabled = false
        case .back:
            rightNavigationButton.isHidden = false
            rightNavigationButton.isEnabled = true
            rightNavigationButton.type = .back
        case .menu:
            rightNavigationButton.isHidden = false
            rightNavigationButton.isEnabled = true
            rightNavigationButton.type = .menu
        }
    }
}
