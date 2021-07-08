////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// BaseNavigationController.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        19.5.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////
final class BaseNavigationController: UIViewController {

    // MARK: - Life cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationStyle = .fullScreen
    }
}
