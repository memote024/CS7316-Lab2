//
//  ModuleBViewController.swift
//  Audio_Lab_2
//
//  Created by Morgan Mote on 9/30/24.
//

import UIKit
import Novocaine

class ModuleBViewController: UIViewController {
    
    var audioManager: Novocaine!
    var fft: FFT!
    var frequencyTone: Float = 18000 // Default to 18kHz for inaudible tone

    @IBOutlet weak var magnitudeLabel: UILabel!
    @IBOutlet weak var gestureLabel: UILabel!
    @IBOutlet weak var frequencySlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioOutput()
    }
    
    func setupAudioOutput() {
        // Initialize audio manager and set up output for inaudible tone
        audioManager = Novocaine.audioManager()
        fft = FFT(size: 1024, sampleRate: Float(audioManager.samplingRate))
        
        audioManager.outputBlock = { (data, numSamples, numChannels) in
            for i in 0..<numSamples {
                let phase = Float(i) * self.frequencyTone / Float(audioManager.samplingRate)
                data[i] = sin(2.0 * .pi * phase) * 0.1 // Generating an inaudible tone
            }
        }

        audioManager.play()
        
        audioManager.inputBlock = { (data, numSamples, numChannels) in
            self.fft.performFFT(withData: data, numSamples: numSamples)
            self.updateMagnitude()
        }
    }
    
    func updateMagnitude() {
        let fftData = fft.getMagnitudeData()
        // Analyze the magnitude near the tone frequency
        let magnitude = fftData[Int(frequencyTone)]
        DispatchQueue.main.async {
            self.magnitudeLabel.text = "\(magnitude) dB"
            self.detectGesture(magnitude: magnitude)
        }
    }
    
    func detectGesture(magnitude: Float) {
        // Doppler shift detection
        if magnitude > 0.5 {
            gestureLabel.text = "Gesture Toward"
        } else if magnitude < 0.2 {
            gestureLabel.text = "Gesture Away"
        } else {
            gestureLabel.text = "No Gesture"
        }
    }

    @IBAction func frequencySliderChanged(_ sender: UISlider) {
        frequencyTone = sender.value
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioManager.pause()
    }
}

