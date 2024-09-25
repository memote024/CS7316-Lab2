//
//  ViewController.swift
//  TheChordApp
//
//  Created by Morgan Mote on 9/24/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // Outlets for all chord buttons
    @IBOutlet weak var chordCButton: UIButton!      // C
    @IBOutlet weak var chordGButton: UIButton!      // G
    @IBOutlet weak var chordDButton: UIButton!      // D
    @IBOutlet weak var chordAButton: UIButton!      // A
    @IBOutlet weak var chordEButton: UIButton!      // E
    @IBOutlet weak var chordBButton: UIButton!      // B
    @IBOutlet weak var chordFSharpButton: UIButton! // F#/Gb
    @IBOutlet weak var chordDbButton: UIButton!     // Db
    @IBOutlet weak var chordAbButton: UIButton!     // Ab
    @IBOutlet weak var chordEbButton: UIButton!     // Eb
    @IBOutlet weak var chordBbButton: UIButton!     // Bb
    @IBOutlet weak var chordFButton: UIButton!      // F

    let audioInputManager = AudioInputManager() // Handles microphone input

    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Listen for chord detection notifications
        NotificationCenter.default.addObserver(self, selector: #selector(handleChordDetected(_:)), name: .chordDetected, object: nil)
    }

    // Handle the notification when a chord is detected
    @objc func handleChordDetected(_ notification: Notification) {
        if let detectedChord = notification.object as? String {
            highlightChord(chord: detectedChord)
        }
    }

    // Highlight the button corresponding to the detected chord
    func highlightChord(chord: String) {
        resetChordHighlights() // Reset all buttons before highlighting

        switch chord {
        case "C":
            chordCButton.backgroundColor = .green
        case "G":
            chordGButton.backgroundColor = .green
        case "D":
            chordDButton.backgroundColor = .green
        case "A":
            chordAButton.backgroundColor = .green
        case "E":
            chordEButton.backgroundColor = .green
        case "B":
            chordBButton.backgroundColor = .green
        case "F#":
            chordFSharpButton.backgroundColor = .green
        case "Db":
            chordDbButton.backgroundColor = .green
        case "Ab":
            chordAbButton.backgroundColor = .green
        case "Eb":
            chordEbButton.backgroundColor = .green
        case "Bb":
            chordBbButton.backgroundColor = .green
        case "F":
            chordFButton.backgroundColor = .green
        default:
            break
        }
    }

    // Reset all chord button highlights
    func resetChordHighlights() {
        chordCButton.backgroundColor = .clear
        chordGButton.backgroundColor = .clear
        chordDButton.backgroundColor = .clear
        chordAButton.backgroundColor = .clear
        chordEButton.backgroundColor = .clear
        chordBButton.backgroundColor = .clear
        chordFSharpButton.backgroundColor = .clear
        chordDbButton.backgroundColor = .clear
        chordAbButton.backgroundColor = .clear
        chordEbButton.backgroundColor = .clear
        chordBbButton.backgroundColor = .clear
        chordFButton.backgroundColor = .clear
    }

    // Action to start recording
    @IBAction func startRecordingPressed(_ sender: UIButton) {
        audioInputManager.startMicrophoneRecording()
    }

    // Action to stop recording
    @IBAction func stopRecordingPressed(_ sender: UIButton) {
        audioInputManager.stopMicrophoneRecording()
    }

    // Start audio recording
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recordedAudio.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
        } catch {
            // Handle error
            print("Recording failed: \(error.localizedDescription)")
        }
    }

    // Stop audio recording
    func stopRecording() {
        audioRecorder.stop()
        audioRecorder = nil
    }

    // Play the recorded audio
    func playRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recordedAudio.m4a")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer.play()
            analyzeAudioDuringPlayback() // Analyze chords during playback
        } catch {
            // Handle error
            print("Playback failed: \(error.localizedDescription)")
        }
    }

    // Analyze the audio during playback and highlight chords
    func analyzeAudioDuringPlayback() {
        // Implement FFT analysis here and update the chord wheel
    }

    // Helper function to get the app's document directory
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    // Alternative: Highlight chord using button tags
    func highlightChord(byTag tag: Int) {
        resetChordHighlights() // Reset all highlights first
        
        if let chordButton = view.viewWithTag(tag) as? UIButton {
            chordButton.backgroundColor = .green  // Example of highlighting
        }
    }
}
