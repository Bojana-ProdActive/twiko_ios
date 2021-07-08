////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// BaseButton.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        8.7.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////
class BaseButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            if isEnabled {
                self.alpha = isHighlighted ? 0.5 : 1.0
            } else {
                self.alpha = 0.0
            }
        }
    }
}
