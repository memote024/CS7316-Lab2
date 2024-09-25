//
//  FFTAnalyzer.swift
//  TheChordApp
//
//  Created by Morgan Mote on 9/24/24.
//

import Foundation
import Accelerate
import AVFoundation

class FFTAnalyzer {
    var fftSetup: FFTSetup?
    let fftSize: Int = 1024
    var log2n: vDSP_Length = 10
    var window: [Float]

    init() {
        self.fftSetup = vDSP_create_fftsetup(log2n, Int32(kFFTRadix2))
        self.window = [Float](repeating: 0.0, count: fftSize)
        vDSP_hann_window(&window, vDSP_Length(fftSize), Int32(vDSP_HANN_DENORM))
    }

    deinit {
        if let setup = fftSetup {
            vDSP_destroy_fftsetup(setup)
        }
    }

    // Perform FFT and get magnitudes
    func performFFT(on buffer: AVAudioPCMBuffer) -> [Float] {
        let frameLength = buffer.frameLength
        let channelData = buffer.floatChannelData![0]

        // Apply window function
        var windowedSamples = [Float](repeating: 0.0, count: fftSize)
        vDSP_vmul(channelData, 1, window, 1, &windowedSamples, 1, vDSP_Length(frameLength))

        // Prepare complex split buffers
        var real = [Float](repeating: 0.0, count: fftSize/2)
        var imaginary = [Float](repeating: 0.0, count: fftSize/2)
        var splitComplex = DSPSplitComplex(realp: &real, imagp: &imaginary)

        windowedSamples.withUnsafeMutableBufferPointer { ptr in
            ptr.baseAddress!.withMemoryRebound(to: DSPComplex.self, capacity: fftSize) {
                vDSP_ctoz($0, 2, &splitComplex, 1, vDSP_Length(fftSize/2))
            }
        }
        vDSP_fft_zrip(fftSetup!, &splitComplex, 1, log2n, Int32(FFT_FORWARD))

        // Compute magnitudes
        var magnitudes = [Float](repeating: 0.0, count: fftSize/2)
        vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(fftSize/2))

        return magnitudes
    }

    // Map detected frequencies to chords
    func detectChord(from magnitudes: [Float], sampleRate: Double = 44100.0) -> String {
        let threshold: Float = 100.0  // Magnitude threshold for noise reduction
        let fftSize = magnitudes.count * 2
        var maxMagnitude: Float = 0
        var dominantFrequency: Double = 0

        // Find the frequency with the highest magnitude
        for (index, magnitude) in magnitudes.enumerated() {
            if magnitude > maxMagnitude && magnitude > threshold {
                maxMagnitude = magnitude
                dominantFrequency = Double(index) * (sampleRate / Double(fftSize))
            }
        }

        // Map dominant frequency to note
        return mapFrequencyToChord(frequency: dominantFrequency)
    }

    // Helper function to map frequencies to notes
    func mapFrequencyToChord(frequency: Double) -> String {
        switch frequency {
        // First Octave
        case 27.500:
            return "A"
        case 29.135:
            return "Bb"
        case 30.868:
            return "B"
        case 32.703:
            return "C"
        case 34.648:
            return "Db"
        case 36.708:
            return "D"
        case 38.891:
            return "Eb"
        case 41.203:
            return "E"
        case 43.654:
            return "F"
        case 46.249:
            return "Gb"
        case 48.999:
            return "G"
        case 51.913:
            return "Ab"
        // Second Octave
        case 55.000:
            return "A"
        case 58.270:
            return "Bb"
        case 61.735:
            return "B"
        case 65.406:
            return "C"
        case 69.296:
            return "Db"
        case 73.416:
            return "D"
        case 77.782:
            return "Eb"
        case 82.407:
            return "E"
        case 87.307:
            return "F"
        case 92.499:
            return "Gb"
        case 97.999:
            return "G"
        case 103.83:
            return "Ab"
        // Third Octave
        case 110.00:
            return "A"
        case 116.54:
            return "Bb"
        case 123.47:
            return "B"
        case 130.81:
            return "C"
        case 138.59:
            return "Db"
        case 146.83:
            return "D"
        case 155.56:
            return "Eb"
        case 164.81:
            return "E"
        case 174.61:
            return "F"
        case 185.00:
            return "Gb"
        case 196.00:
            return "G"
        case 207.65:
            return "Ab"
        // Fourth Octave
        case 220.00:
            return "A"
        case 233.08:
            return "Bb"
        case 246.94:
            return "B"
        case 261.63:
            return "C"
        case 277.18:
            return "Db"
        case 293.66:
            return "D"
        case 311.13:
            return "Eb"
        case 329.63:
            return "E"
        case 349.23:
            return "F"
        case 369.99:
            return "Gb"
        case 392.00:
            return "G"
        case 415.30:
            return "Ab"
        // Fifth Octave
        case 440.00:
            return "A"
        case 466.16:
            return "Bb"
        case 493.88:
            return "B"
        case 523.25:
            return "C"
        case 554.37:
            return "Db"
        case 587.33:
            return "D"
        case 622.25:
            return "Eb"
        case 659.25:
            return "E"
        case 698.46:
            return "F"
        case 739.99:
            return "Gb"
        case 783.99:
            return "G"
        case 830.61:
            return "Ab"
        // Sixth Octave
        case 880.00:
            return "A"
        case 932.33:
            return "Bb"
        case 987.77:
            return "B"
        case 1046.5:
            return "C"
        case 1108.7:
            return "Db"
        case 1174.7:
            return "D"
        case 1244.5:
            return "Eb"
        case 1318.5:
            return "E"
        case 1396.9:
            return "F"
        case 1480.0:
            return "Gb"
        case 1568.0:
            return "G"
        case 1661.2:
            return "Ab"
        // Seventh Octave
        case 1760.0:
            return "A"
        case 1864.7:
            return "Bb"
        case 1979.5:
            return "B"
        case 2093.0:
            return "C"
        case 2217.5:
            return "Db"
        case 2349.3:
            return "D"
        case 2489.0:
            return "Eb"
        case 2637.0:
            return "E"
        case 2793.0:
            return "F"
        case 2960.0:
            return "Gb"
        case 3136.0:
            return "G"
        case 3322.4:
            return "Ab"
        // Eighth Octave
        case 3520.0:
            return "A"
        case 3729.3:
            return "Bb"
        case 3951.1:
            return "B"
        case 4186.0:
            return "C"
        
        default:
            return ""
        }
    }
}
