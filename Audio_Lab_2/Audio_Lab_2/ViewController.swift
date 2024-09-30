//
//  ViewController.swift
//  Audio_Lab_2
//
//  Created by Morgan Mote on 9/30/24.
//

import UIKit

class LandingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Any additional setup can go here
    }

    // So button presses can be handled
    @IBAction func goToModuleA(_ sender: UIButton) {
        performSegue(withIdentifier: "goToModuleA", sender: self)
    }

    @IBAction func goToModuleB(_ sender: UIButton) {
        performSegue(withIdentifier: "goToModuleB", sender: self)
    }
}


