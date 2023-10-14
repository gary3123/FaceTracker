//
//  MainViewController.swift
//  FaceTracker
//
//  Created by imac-3570 on 2023/10/13.
//

import UIKit
import ARKit

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var vARSCN: ARSCNView!
    
    // MARK: - Variables
    
    var result = ""
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vARSCN.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let config = ARFaceTrackingConfiguration()
        vARSCN.session.run(config)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    
    // MARK: - IBAction
    
    func judgeFace(anchor: ARFaceAnchor) {
        let smileLeft = anchor.blendShapes[.mouthSmileLeft]
        let smileRight = anchor.blendShapes[.mouthSmileRight]
        let tongueOut = anchor.blendShapes[.tongueOut]
        
        if ((smileLeft?.decimalValue ?? 0.0) + (smileRight?.decimalValue ?? 0.0)) > 0.9 {
            result = "微笑中"
        }
        
        if (tongueOut?.decimalValue ?? 0.0) > 0.9 {
            result = "吐舌頭中"
        }
    }
    
}

// MARK: - Extension

extension MainViewController: ARSCNViewDelegate  {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let faceMesh = ARSCNFaceGeometry(device: vARSCN.device!)
        let node = SCNNode(geometry: faceMesh)
        node.geometry?.firstMaterial?.fillMode = .lines
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry {
            faceGeometry.update(from: faceAnchor.geometry)
            judgeFace(anchor: faceAnchor as! ARFaceAnchor)
            print(result)
        }
    }
    
}

// MARK: - Protocol

