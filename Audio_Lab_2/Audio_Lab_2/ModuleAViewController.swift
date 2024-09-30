//
//  ModuleAViewController.swift
//  Audio_Lab_2
//
//  Created by Morgan Mote on 9/30/24.
//

import UIKit
import Novocaine // Ensure you add the Novocaine library to your project

class ModuleAViewController: UIViewController {
    
    var audioManager: Novocaine!
    var fft: FFT!
    
    @IBOutlet weak var frequencyLabel1: UILabel!
    @IBOutlet weak var frequencyLabel2: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioProcessing()
    }

    func setupAudioProcessing() {
        // Initialize audio manager and FFT processor
        audioManager = Novocaine.audioManager()
        fft = FFT(size: 1024, sampleRate: Float(audioManager.samplingRate))

        audioManager.inputBlock = { (data, numSamples, numChannels) in
            self.fft.performFFT(withData: data, numSamples: numSamples)
            self.updateFrequencyLabels()
        }
        
        audioManager.play()
    }

    func updateFrequencyLabels() {
        let loudestFrequencies = findTwoLoudestFrequencies()
        DispatchQueue.main.async {
            self.frequencyLabel1.text = "\(loudestFrequencies.0) Hz"
            self.frequencyLabel2.text = "\(loudestFrequencies.1) Hz"
        }
    }

    func findTwoLoudestFrequencies() -> (Float, Float) {
        let fftData = fft.getMagnitudeData()
        // Peak finding algorithm logic to return the two loudest frequencies
        let frequency1: Float = 440.0 // Replace with actual peak value
        let frequency2: Float = 550.0 // Replace with actual peak value
        return (frequency1, frequency2)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioManager.pause()
    }
}

