////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// UIButton.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        20.5.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////
private var kKeyHitEdge = "hitEdgeInsets"

extension UIButton {
    public var hitEdgeInsets: UIEdgeInsets {
        get {
            let value = objc_getAssociatedObject(self, &kKeyHitEdge)
            if value != nil {
                if let value = value as? UIEdgeInsets {
                    var edgeInsets = UIEdgeInsets()
                    edgeInsets = value
                    return edgeInsets
                }
                return .zero
            } else {
                return .zero
            }
        }
        set {
            let value = newValue
            objc_setAssociatedObject(self, &kKeyHitEdge, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if hitEdgeInsets == .zero || !isEnabled || isHidden {
            return super.point(inside: point, with: event)
        }

        let relativeFrame = bounds
        let hitFrame = relativeFrame.inset(by: hitEdgeInsets)

        return hitFrame.contains(point)
    }
}
