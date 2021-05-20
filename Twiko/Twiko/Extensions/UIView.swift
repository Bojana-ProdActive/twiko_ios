////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// UIView.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        20.5.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////

// MARK: - Frame additions

extension UIView {

    /// X origin
    var x: CGFloat {
        get {
            return frame.origin.x
        }

        set {
            frame = CGRect(x: newValue, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        }
    }

    /// Y origin
    var y: CGFloat {
        get {
            return frame.origin.y
        }

        set {
            frame = CGRect(x: x, y: newValue, width: frame.size.width, height: frame.size.height)
        }
    }

    /// Width
    var width: CGFloat {
        get {
            return frame.size.width
        }

        set {
            frame = CGRect(x: x, y: y, width: newValue, height: frame.size.height)
        }
    }

    /// Height
    var height: CGFloat {
        get {
            return frame.size.height
        }

        set {
            frame = CGRect(x: x, y: y, width: width, height: newValue)
        }
    }

    /// End X origin
    var right: CGFloat {
        return frame.maxX
    }

    /// End Y origin
    var bottom: CGFloat {
        return frame.maxY
    }

    /// Origin
    var origin: CGPoint {
        get {
            return frame.origin
        }

        set {
            frame = CGRect(x: newValue.x, y: newValue.y, width: width, height: height)
        }
    }

    /// Size
    var size: CGSize {
        get {
            return frame.size
        }

        set {
            frame = CGRect(x: x, y: y, width: newValue.width, height: newValue.height)
        }
    }
}

// MARK: - Contraints

extension UIView {

    /// Create object instance with **translatesAutoresizingMaskIntoConstraints=false**
    static func newAutoLayoutView() -> Self {
        let view = self.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    /// Pin view to safe area edges of passed view
    /// - Parameter view: referent view
    func pinToSafeArea(ofView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    /// Pin  edges to enges of passed view.
    /// - Parameters:
    ///   - view: Referent view
    ///   - insets: Edge insets
    func pinToEdges(ofView view: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
        ])
    }
}
