////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// UILabel.swift
//
// AUTHOR IDENTITY:
//        Bojana Vojvodic        5.7.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////
extension String {

    func getAttributedStringWithSpacing(spacing: CGFloat) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self, attributes: nil)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
}
