////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// UITableViewHeaderFooterView.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        20.5.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////
extension UITableViewHeaderFooterView {
    public class var reuseIdentifier: String {
        return String(describing: self)
    }

    public class var nibIdentifier: String {
        return String(describing: self)
    }
}
