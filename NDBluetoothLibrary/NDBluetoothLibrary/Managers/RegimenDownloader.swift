////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm NDBluetoothLibrary
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// RegimenDownloader.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        23.6.21.
//
////////////////////////////////////////////////////////////////////////////////
import Foundation
////////////////////////////////////////////////////////////////////////////////
protocol RegimenDownloaderInterface {

   var isDownloading: Bool { get }

    /**
     Download regimens from the pump

     - parameter handler: Callback function which will be called on success/failure.
     */
    func download( _ handler: ((Result<[PumpRegimen], Error>) -> Void)?)
}

extension RegimenDownloader {
    public enum DownloaderError: Error {

        /// Downloading is not availabel at this moment.
        case downloadRegimensIsUnavailable
    }
}

final class RegimenDownloader: RegimenDownloaderInterface {

    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .default
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    private weak var pumpManager: PumpManager?
    private(set) var isDownloading: Bool = false
    private var activeRegimenIndex: Int32 = -1
    private var regimenSize: UInt32 = 0
    private var downloadingRegimenIndex: UInt32 = 0
    private var segmentsSize: UInt32 = 0
    private var downloadingRegimen: PumpRegimen?
    private var regimens: [PumpRegimen] = []
    private var callback: ((Result<[PumpRegimen], Error>) -> Void)?

    init(pumpManager: PumpManager) {
        self.pumpManager = pumpManager
    }

    func download( _ handler: ((Result<[PumpRegimen], Error>) -> Void)?) {
        guard !isDownloading else {
            handler?(.failure(DownloaderError.downloadRegimensIsUnavailable))
            return
        }

        isDownloading = true
        callback = handler
        resetData()
        readInitialData()
    }

    private func resetData() {
        activeRegimenIndex = -1
        regimenSize = 0
        downloadingRegimenIndex = 0
        segmentsSize = 0
        downloadingRegimen = nil
        regimens = []
    }

    /**
     Execute initial commands:
     - Read active regimen index
     - Read regimen size
     - Send download command
     */
    private func readInitialData() {
        // Read active regimen index
        operationQueue.addOperation {
            self.operationQueue.isSuspended = true
            self.readActiveRegimenIndex { result in
                switch result {
                case .success:
                    self.operationQueue.isSuspended = false
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }

        // Read regimen size
        operationQueue.addOperation {
            self.operationQueue.isSuspended = true
            self.readRegimenSize { result in
                switch result {
                case .success(let size):
                    self.regimenSize = size
                    self.operationQueue.isSuspended = false
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }

        // Send download regimens command
        operationQueue.addOperation {
            self.operationQueue.isSuspended = true
            self.pumpManager?.sendStartRegimenDownloadCommand({ result in
                switch result {
                case .success:
                    self.operationQueue.isSuspended = false
                    self.downloadNextRegimen()
                case .failure(let error):
                    self.handleError(error)
                }
            })
        }
    }

    /**
     Dowload regimen with next pointer.
     - Write regimen pointer
     - Read segments number
     - Download segments
     */
    private func downloadNextRegimen() {
        guard downloadingRegimenIndex < regimenSize else {
            Log.e("Download regimen index is low")
            return
        }

        // Create new downloading regimen object

        downloadingRegimen = PumpRegimen()
        // Write regimen pointer
        operationQueue.addOperation {
            self.operationQueue.isSuspended = true
            self.writeRegimenPointer(pointer: self.downloadingRegimenIndex) { result in
                switch result {
                case .success:
                    self.operationQueue.isSuspended = false
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }

        // Read number of segments
        operationQueue.addOperation {
            self.operationQueue.isSuspended = true
            self.readNumberOfSegments { result in
                switch result {
                case .success(let segmentsNumber):
                    self.segmentsSize = segmentsNumber
                    self.downloadSegmentsForLastWrittenRegimenPointer()
                    self.operationQueue.isSuspended = false
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }

    /*
     Download all segments for last written regimen pointer
     */
    func downloadSegmentsForLastWrittenRegimenPointer() {
        for pointer in 0 ..< segmentsSize {
            downloadSegment(atPointer: pointer, isLast: pointer == segmentsSize - 1)
        }
    }

    /**
     Download segment at pointer postion.
     - Write segment pointer
     - Read segment time
     - Read segment value

     - parameter pointer: Ordinal number of segment inside the regimen.
     - parameter isLast: Is last segment in regimen.
     */
    func downloadSegment(atPointer pointer: UInt32, isLast: Bool) {
        var segment = PumpRegimenSegment()

        // Write segment pointer
        operationQueue.addOperation {
            self.operationQueue.isSuspended = true
            self.writeRegimenSegmentPointer(pointer: pointer) { result in
                switch result {
                case .success:
                    self.operationQueue.isSuspended = false
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }

        // Read segment time
        operationQueue.addOperation {
            self.operationQueue.isSuspended = true
            self.readRegimenSegmentTime { result in
                switch result {
                case .success(let time):
                    segment.startTime = time
                    self.operationQueue.isSuspended = false
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }

        // Read segment value
        operationQueue.addOperation {
            self.operationQueue.isSuspended = true
            self.readRegimenSegmentValue { result in
                switch result {
                case .success(let value):
                    segment.value = value
                    self.downloadingRegimen?.segments.append(segment)
                    if isLast {
                        self.regimens.append(self.downloadingRegimen!)
                        self.downloadingRegimenIndex += 1
                        if self.downloadingRegimenIndex < self.regimenSize {
                            self.downloadNextRegimen()
                        } else {
                            self.returnSuccess()
                        }
                    }
                    self.operationQueue.isSuspended = false
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }

    private func handleError(_ error: Error) {
        Log.w(error)
        operationQueue.cancelAllOperations()
        operationQueue.isSuspended = false
        isDownloading = false
        callback?(.failure(error))
    }

    private func returnSuccess() {
        Log.i("Regimens downloaded")
        callback?(.success(regimens))
        callback = nil
        isDownloading = false
    }
}

// MARK: - Comuntication with pump

extension RegimenDownloader {
    func readRegimenSize(handler: ((Result<UInt32, Error>) -> Void)?) {
        Log.i("")
        pumpManager?.readRawData(.regimenSize, handler: { result in
            switch result {
            case .success(let data):
                var size: UInt32 = 0
                if let data = data {
                    size = UInt32.create(fromBigEndian: data)
                }
                Log.d("Size: \(size)")
                handler?(.success(size))
            case .failure(let error):
                Log.w(error)
                handler?(.failure(error))
            }
        })
    }

    func readActiveRegimenIndex(handler: ((Result<Int32, Error>) -> Void)?) {
        Log.i("")
        pumpManager?.readRawData(.regimenSize, handler: { result in
            switch result {
            case .success(let data):
                var regimenIndex: Int32 = -1
                if let data = data {
                    regimenIndex = Int32.create(fromBigEndian: data)
                }
                Log.d("Active regimen index: \(regimenIndex)")
                handler?(.success(regimenIndex))
            case .failure(let error):
                Log.w(error)
                handler?(.failure(error))
            }
        })
    }

    func writeRegimenPointer(pointer: UInt32, handler: ((Result<Bool, Error>) -> Void)?) {
        Log.i("")
        let data = Data(pointer.bigEndian.toBytes)
        pumpManager?.writeRawData(data, characteristicType: .regimenPointer, handler: { result in
            switch result {
            case .success:
                Log.d("Written \(pointer)")
                handler?(.success(true))
            case .failure(let error):
                Log.w(error)
                handler?(.failure(error))
            }
        })
    }

    func readNumberOfSegments(handler: ((Result<UInt32, Error>) -> Void)?) {
        Log.i("")
        pumpManager?.readRawData(.numberOfSegmentsInRegimen, handler: { result in
            switch result {
            case .success(let data):
                var numberOfSegments: UInt32 = 0
                if let data = data {
                    numberOfSegments = UInt32.create(fromBigEndian: data)
                }
                Log.d("Segments number: \(numberOfSegments)")
                handler?(.success(numberOfSegments))
            case .failure(let error):
                Log.w(error)
                handler?(.failure(error))
            }
        })
    }

    func writeRegimenSegmentPointer(pointer: UInt32, handler: ((Result<Bool, Error>) -> Void)?) {
        Log.i("")
        let data = Data(pointer.bigEndian.toBytes)
        pumpManager?.writeRawData(data, characteristicType: .regimenSegmentPointer, handler: { result in
            switch result {
            case .success:
                Log.d("Written \(pointer)")
                handler?(.success(true))
            case .failure(let error):
                Log.w(error)
                handler?(.failure(error))
            }
        })
    }

    func readRegimenSegmentTime(handler: ((Result<UInt64, Error>) -> Void)?) {
        Log.i("")
        pumpManager?.readRawData(.regimenSegmentTime, handler: { result in
            switch result {
            case .success(let data):
                var segmentValue: UInt64 = 0
                if let data = data {
                    segmentValue = UInt64.create(fromBigEndian: data)
                }
                Log.d("Segments value: \(segmentValue)")
                handler?(.success(segmentValue))
            case .failure(let error):
                Log.w(error)
                handler?(.failure(error))
            }
        })
    }

    func readRegimenSegmentValue(handler: ((Result<UInt64, Error>) -> Void)?) {
        Log.i("")
        pumpManager?.readRawData(.regimenSegmentValue, handler: { result in
            switch result {
            case .success(let data):
                var segmentValue: UInt64 = 0
                if let data = data {
                    segmentValue = UInt64.create(fromBigEndian: data)
                }
                Log.d("Segments value: \(segmentValue)")
                handler?(.success(segmentValue))
            case .failure(let error):
                Log.w(error)
                handler?(.failure(error))
            }
        })
    }
}
