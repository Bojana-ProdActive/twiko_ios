////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// UIFont.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        5.7.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////
extension UIFont {

    /// BarlowSemiCondensed font family
    ///
    /// - Parameters:
    ///   - size: size of the font
    ///   - weight: weight of the font
    /// - Returns: formatted font
    class func primary(size: CGFloat, weight: Weight) -> UIFont {
        var font = FontFamily.BarlowSemiCondensed.semiBold
        switch weight {
        case .semibold:
            font = FontFamily.BarlowSemiCondensed.semiBold
        default:
            break
        }
        guard let customFont = FontConvertible.Font(font: font, size: size) else {
            fatalError("""
                    Failed to load the "\(font.name)" font.
                    Make sure the font file is included in the project and the font name is spelled correctly.
                    """
            )
        }
        return customFont
    }

    /// Barlow font family
    ///
    /// - Parameters:
    ///   - size: size of the font
    ///   - weight: weight of the font
    /// - Returns: formatted font
    class func secondary(size: CGFloat, weight: Weight) -> UIFont {
        var font = FontFamily.Barlow.bold
        switch weight {
        case .bold:
            font = FontFamily.Barlow.bold
        default:
            break
        }
        guard let customFont = FontConvertible.Font(font: font, size: size) else {
            fatalError("""
                    Failed to load the "\(font.name)" font.
                    Make sure the font file is included in the project and the font name is spelled correctly.
                    """
            )
        }
        return customFont
    }
}
