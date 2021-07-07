////////////////////////////////////////////////////////////////////////////////
//
// NeuroDerm Twiko
// Copyright (c) 2021 NeuroDerm
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by NeuroDerm.
//
// AlarmPlayer.swift
//
// AUTHOR IDENTITY:
//        Goran Tokovic        6.7.21.
//
////////////////////////////////////////////////////////////////////////////////
import AVFoundation
import Foundation
////////////////////////////////////////////////////////////////////////////////
protocol AlarmPlayerInterface {

    /**
     Play high priority alarm audio.
     */
    func playHighPriorityAlert()

    /**
     Play medium priority alarm audio.
     */
    func playMediumPriorityAlert()

    /**
     Play low priority alarm audio.
     */
    func playLowPriorityAlert()
}

final class AlarmPlayer: AlarmPlayerInterface {

    private var newPlayer: AVAudioPlayer?

    func playHighPriorityAlert() {
        playMp3(withName: "nd_hp_alarm")
    }

    func playMediumPriorityAlert() {
        playMp3(withName: "nd_med_alarm")
    }

    func playLowPriorityAlert() {
        playMp3(withName: "nd_lp_alarm")
    }

    private func playMp3(withName name: String) {
        // Does file exist
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            return
        }

        // Stop active audio playing
        if newPlayer?.isPlaying == true {
            newPlayer?.stop()
        }

        // Create new player
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            newPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        } catch let error {
            debugPrint("[AlarmPlayer playMp3] Error: \(error)")
            return
        }

        // Start playing
        newPlayer?.volume = 1
        newPlayer?.prepareToPlay()
        newPlayer?.play()
    }
}
