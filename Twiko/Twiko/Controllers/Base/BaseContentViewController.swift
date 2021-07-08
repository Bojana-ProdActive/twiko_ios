////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// BaseContentViewController.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        7.7.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////
class BaseContentViewController: BaseViewController {

    // MARK: - Enums

    enum InformationPanelType {

        /**
         Hidden info pannel
         */
        case none

        /**
         Visible info panel with width=206
         */
        case narrow

        /**
         Visible info panel with width=404
         */
        case wide

        fileprivate var width: CGFloat {
            switch self {
            case .none:
                return 0
            case .narrow:
                return 260
            case .wide:
                return 404
            }
        }
    }

    // MARK: - UI components

    private lazy var navigationView: NavigationView = {
        let view = NavigationView.newAutoLayoutView()
        view.rightNavigationButton.addTarget(self, action: #selector(navigationButtonDidTap(_:)), for: .touchUpInside)
        return view
    }()

    private(set) lazy var informationPanelView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = Asset.Colors.ndPurple.color
        return view
    }()

    private(set) lazy var contentView: UIView = UIView.newAutoLayoutView()

    // MARK: - Life cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        configureConstraints()
        title = String(describing: type(of: self))
    }

    func configureConstraints() {
        // Navigation view
        view.addSubview(navigationView)
        let height: CGFloat = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: view.topAnchor, constant: height),
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Info view
        view.insertSubview(informationPanelView, belowSubview: navigationView)
        let widthConstraint = informationPanelView.widthAnchor.constraint(equalToConstant: infoPanelType.width)
        widthConstraint.priority = UILayoutPriority(999) // The highest priority
        NSLayoutConstraint.activate([
            informationPanelView.topAnchor.constraint(equalTo: view.topAnchor),
            informationPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            informationPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            widthConstraint
        ])

        // Content view
        view.insertSubview(contentView, belowSubview: navigationView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: informationPanelView.leadingAnchor)
        ])
    }

    // MARK: - View controller

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        additionalSafeAreaInsets = UIEdgeInsets(top: navigationView.height, left: additionalSafeAreaInsets.left, bottom: additionalSafeAreaInsets.bottom, right: additionalSafeAreaInsets.right)
    }

    override var title: String? {
        get {
            return navigationView.title
        }

        set {
            navigationView.title = newValue
        }
    }

    // MARK: - Navigation view

    var navigationButtonType: NavigationView.NavigationButtonType {
        get {
            return navigationView.navigationButtonType
        }

        set {
            navigationView.navigationButtonType = newValue
        }
    }

    var isNavigationBarHidden: Bool = false {
        didSet {
            navigationView.isHidden = isNavigationBarHidden
        }
    }

    // MARK: - Info panel

    /**
     Info panel type.

     Default type is **none**
     */
    var infoPanelType: InformationPanelType {
        return .none
    }

    // MARK: - Actions

    /**
     Action called on navigation button tap
     */
    @objc func navigationButtonDidTap(_ button: NavigationButton) {
        debugPrint("[\(String(describing: type(of: self))) navigationButtonDidTap]")
    }
}
