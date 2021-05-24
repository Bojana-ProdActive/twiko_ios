//
//  ViewController.swift
//  Twiko
//
//  Created by Goran Tokovic on 19.5.21..
//

import NDBluetoothLibrary
import UIKit

class ViewController: UIViewController {

    private lazy var button: Button = {
        let button = Button(type: .primary)
        button.setTitle("Test", for: .normal)
        return button
    }()

    private lazy var infoLabel: Label = {
        let label = Label(type: .body)
        label.textAlignment = .center
        label.text = "Test Label"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Button
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UI.defaultPadding),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UI.defaultPadding)
        ])

        // Label
        view.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: UI.defaultPadding),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UI.defaultPadding),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UI.defaultPadding)
        ])
    }
}
