//
//  ViewController.swift
//  ARPokerDice
//
//  Created by wangliang on 2022/9/14.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    var trackingStatus: String = ""

    // MARK: -- Outlets
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var styleButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet var sceneView: ARSCNView!
    
    // MARK: - Actions
    @IBAction func styleButtonPressed(_ sender: Any) {
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
    }
    
    
    // MARK: - View Management
    override func viewDidLoad() {
        super.viewDidLoad()
        initSceneView()
        initScene()
        initARSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("*** viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("*** viewWillDisappear")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Initialization
    func initSceneView() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [
            SCNDebugOptions.showFeaturePoints,
            SCNDebugOptions.showWorldOrigin,
            SCNDebugOptions.showBoundingBoxes,
            SCNDebugOptions.showWireframe
        ]
    }
    
    func initScene() {
        let scene = SCNScene(named: "PockerDice.scnassets/SimpleScene.scn")!
        scene.isPaused = false
        sceneView.scene = scene
    }
    
    func initARSession() {
        guard ARWorldTrackingConfiguration.isSupported else {
            print("*** ARConfig: AR Word Tracking not supported")
            return
        }
        let config = ARWorldTrackingConfiguration()
        config.worldAlignment = .gravity
        config.providesAudioData = false
        sceneView.session.run(config)
    }
    
}

extension ViewController: ARSCNViewDelegate {
    // MARK: - SceneKit Management
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.statusLabel.text = self.trackingStatus
        }
    }
    
    // MARK: - Session State Management
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .notAvailable:
            trackingStatus = "Tracking: not available"
            break
        case .normal:
            trackingStatus = ""
            break
        case .limited(let reason):
            switch reason {
            case .initializing:
                trackingStatus = "Tracking: initializing"
            case .excessiveMotion:
                trackingStatus = "Tracking: limited due to excessive motion"
            case .insufficientFeatures:
                trackingStatus = "Tracking: limited due to insufficient features"
            case .relocalizing:
                trackingStatus = "Tracking: relocalizing"
            @unknown default:
                trackingStatus = "Tracking: unknow..."
            }
        }
    }
    
    // MARK: - Session Error Managent
    func session(_ session: ARSession, didFailWithError error: Error) {
        trackingStatus = "AR Session Failure: \(error)"
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        trackingStatus = "AR Session was interrupted!"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
      trackingStatus = "AR Session Interruption Ended"
    }
    
    // MARK: - Plane Management
}
