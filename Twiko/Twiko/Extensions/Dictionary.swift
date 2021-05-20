////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// Dictionary.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        20.5.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
final class Dictionary {

    /// Convert dictionary to JSON string using UTF8 encoding
    var jsonString: String? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
