//
//  AppDelegate.swift
//  TheChordApp
//
//  Created by Morgan Mote on 9/24/24.
//
//  MAIN FEATURES TO IMPLEMENT:
//  Chord Wheel UI: A circular chord wheel where each chord is represented as a button, and when a chord is detected via FFT, the respective button on the wheel is highlighted.
//  Audio Input (Microphone): The app will record audio input and perform real-time FFT to detect frequencies.
//  Chord Detection: Convert frequencies to musical chords and highlight the corresponding buttons on the wheel.
//  Recording and Playback: The app will allow users to record audio and play it back with the chord detection continuing during playback.
//  MVC (Model-View-Controller): The FFT analysis and audio handling will follow the MVC pattern, keeping the logic in the model and the UI in the view controller.

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

