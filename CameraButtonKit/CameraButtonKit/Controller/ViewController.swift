//
//  ViewController.swift
//  CameraButtonKit
//
//  Created by jaydeep godhani on 04/06/25.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var cameraButton: CameraButtonView!
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.initialConfig()
    }
    
    // MARK: - Helper Functions
    
    // Initial Config
    func initialConfig() {
        self.setupCameraButton()
    }
    
    // Setup Camera Button
    func setupCameraButton() {
        self.cameraButton.delegate = self
    }
    
}

// MARK: - Extension

// MARK: CameraButtonDelegate
extension ViewController: CameraButtonDelegate {
    
    func onStartRecord() {
        
    }
    
    func onEndRecord() {
        
    }
    
    func onDurationTooShortError() {
        
    }
    
    func onSingleTap() {
        
    }
    
    func onCancelled() {
        
    }
    
}
