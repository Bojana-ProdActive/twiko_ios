////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// PriorityCommand.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        1.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
final class PriorityCommand {
    let type: CommandType
    let priority: Int
    let characteristic: Characteristic
    let handler: ((_ result: Result<Data?, Error>) -> Void)?

    init(type: CommandType, priority: Int, characteristic: Characteristic, handler: ((_ result: Result<Data?, Error>) -> Void)?) {
        self.type = type
        self.priority = priority
        self.characteristic = characteristic
        self.handler = handler
    }
}

extension PriorityCommand: Comparable {
    static func == (lhs: PriorityCommand, rhs: PriorityCommand) -> Bool {
        return lhs.priority == rhs.priority
    }

    static func < (lhs: PriorityCommand, rhs: PriorityCommand) -> Bool {
        return lhs.priority < rhs.priority
    }
}
