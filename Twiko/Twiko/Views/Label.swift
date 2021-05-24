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
import UIKit
////////////////////////////////////////////////////////////////////////////////
final class Label: UILabel {

    enum LabelType {
        case body
    }

    // MARK: - Data

    let type: LabelType

    // MARK: - Initialization

    init(type: LabelType) {
        self.type = type
        super.init(frame: .zero)
        commonInit()
    }

    override init(frame: CGRect) {
        type = .body
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        type = .body
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0

        setAppearanceByType()
    }

    private func setAppearanceByType() {
        switch type {
        case .body:
            textColor = .green
        }
    }
}
