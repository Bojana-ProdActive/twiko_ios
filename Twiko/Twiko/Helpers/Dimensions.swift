////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// Dimensions.swift
//
// AUTHOR IDENTITY:
//        Digital Atrium        14.7.21.
//
////////////////////////////////////////////////////////////////////////////////
import UIKit
////////////////////////////////////////////////////////////////////////////////
final class Dimensions {

    static var dialogViewHeight: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 382
        default:
            return 260
        }
    }

    static var dialogViewWidth: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 840
        default:
            return 600
        }
    }

    static var alarmDialogViewHeight: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 255
        default:
            return 130
        }
    }

    static var alarmViewHeight: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 320
        default:
            return 220
        }
    }

    static var alarmViewWidth: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 944
        default:
            return 650
        }
    }

    static var audioButtonHeight: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 50
        default:
            return 35
        }
    }

    static var audioButtonWidth: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 235
        default:
            return 150
        }
    }
}
