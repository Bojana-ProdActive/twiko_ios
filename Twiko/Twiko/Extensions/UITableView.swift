////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// UITableView.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        20.5.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////
extension UITableView {
    /**
     Registers a cell class with the table view using the class's default reuse identifier.
     */
    func registerCellClass(_ cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.defaultReuseIdentifier)
    }

    /**
     Dequeues and returns a cell of the specified class, using the cell class's default reuse identifier.
     */
    func dequeueReusableCell<T: UITableViewCell>(atIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Incorrect type for dequeued cell with identifier:\(T.defaultReuseIdentifier)")
        }

        return cell
    }

    /**
     Registers a header/footer class with the table view using the class's default reuse identifier.
     */
    func registerHeaderFooterClass(_ headerFooterClass: UITableViewHeaderFooterView.Type) {
        register(headerFooterClass, forHeaderFooterViewReuseIdentifier: headerFooterClass.reuseIdentifier)
    }

    /**
     Dequeues and returns a header/footer ciew of the specified class, using the header/footer class's default reuse identifier.
     */
    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>() -> T {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Incorrect type for dequeued header/footer with identifier:\(T.reuseIdentifier)")
        }

        return headerFooterView
    }
}
