////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// RegimenManager.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        23.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
protocol RegimenManagerInterface {
    /**
     Download regimens from the pump

     - parameter handler: Callback function which will be called on success/failure.
     */
    func download( _ handler: ((Result<[PumpRegimen], Error>) -> Void)?)
}

final class RegimenManager {

    private let regimenDownloader: RegimenDownloaderInterface

    init(regimenDownloader: RegimenDownloaderInterface) {
        self.regimenDownloader = regimenDownloader
    }

    func download( _ handler: ((Result<[PumpRegimen], Error>) -> Void)?) {
        // Download and upload are not allowed at same time
        guard !regimenDownloader.isDownloading else {
            handler?(.failure(RegimenDownloader.DownloaderError.downloadRegimensIsUnavailable))
            return
        }

        // TODO: Handle isUploading state
        regimenDownloader.download(handler)
    }
}
