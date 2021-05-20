////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// Decodable.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        20.5.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
public extension Decodable {

    /// Init decodable object from dictionary/array
    /// - Parameter from: Can be object of Array or Dictionary
    /// - Throws: throwing exception if is not possible to convert to decodable model
    init(fromAny from: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        self = try decoder.decode(Self.self, from: data)
    }
}
