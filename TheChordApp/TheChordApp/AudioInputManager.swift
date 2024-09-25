//
//  AudioInputManager.swift
//  TheChordApp
//
//  Created by Morgan Mote on 9/24/24.
//

import Foundation
import AVFoundation

class AudioInputManager {
    private let audioEngine = AVAudioEngine()
    private let fftAnalyzer = FFTAnalyzer()

    func startMicrophoneRecording() {
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, time in
            let magnitudes = self.fftAnalyzer.performFFT(on: buffer)
            let detectedChord = self.fftAnalyzer.detectChord(from: magnitudes)
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .chordDetected, object: detectedChord)
            }
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
    }

    func stopMicrophoneRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}

extension Notification.Name {
    static let chordDetected = Notification.Name("chordDetected")
}
