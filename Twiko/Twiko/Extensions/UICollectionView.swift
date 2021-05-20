////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// UICollectionView.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        20.5.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////
extension UICollectionView {

    /// Register collection view cell with default reuse identifier
    /// - Parameter : Type of custom collection view cell
    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.cellIdentifier)
    }

    /// Dequeues and returns a cell of the specified class, using the cell class's default reuse identifier.
    /// - Parameter indexPath:
    /// - Returns:
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.cellIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.cellIdentifier)")
        }

        return cell
    }
}
