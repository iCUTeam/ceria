//
//  GameViewController.swift
//  Ceria
//
//  Created by Kevin Gosalim on 10/10/22.
//

import UIKit
import SceneKit
import RealityKit
import ARKit
import SwiftySound

class ExploreViewController: UIViewController, ARSCNViewDelegate, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    @IBOutlet var arSCN: ARSCNView!
    @IBOutlet weak var bottomPrimaryConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomSecondaryConstraint: NSLayoutConstraint!
    @IBOutlet weak var instructionViewPrimary: ClueExploration!
    @IBOutlet weak var instructionViewSecondary: ClueExploration!
    
    let defaults = UserDefaults.standard
    
    private lazy var homeButton: MakeButton = {
        let button = MakeButton(image: "home.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        return button
    }()
    
    var blueCheckPointNode : SCNNode? = nil
    
    var redCheckPointNode : SCNNode? = nil
    
    var greenCheckPointNode : SCNNode? = nil
//
    var seraungNode: SCNNode? = nil
//
    var tarumpahNode: SCNNode? = nil
//
    var tinimiNode: SCNNode? = nil

    var lontongNode: SCNNode? = nil
    
    private let collectionViewModel = CollectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(homeButton)
        setUpAutoLayout()
        
        // Set the view's delegate
        arSCN.delegate = self
        
        // Show statistics such as fps and timing information
        arSCN.showsStatistics = true
        
        arSCN.autoenablesDefaultLighting = true
        
        //set primary clue data
        instructionViewPrimary.clueDescription.text = getDescClue(clueCode: 1)
        instructionViewPrimary.clueGreyBackView.layer.cornerRadius = 20
        instructionViewPrimary.clueImage.image = UIImage(named: "red-card")
        
        //set second clue data
        instructionViewSecondary.clueDescription.text = getDescClue(clueCode: 2)
        instructionViewSecondary.clueGreyBackView.layer.cornerRadius = 20
        instructionViewSecondary.clueImage.image = UIImage(named: "blue-card")
        
        
        Sound.play(file: "explore2-intro.m4a")
        
        if defaults.string(forKey: "userState") == "clear_story_1"
        {
            collectionViewModel.initializeCollection()
        }
    }
    
    //MARK: TEMPORARY FOR CODE TESTING
    @IBAction func showedPressed(_ sender: Any) {
        UIView.animate(withDuration: 1) {
            //constraint play
            self.bottomPrimaryConstraint.constant = 10
            self.bottomSecondaryConstraint.constant = 150
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: TEMPORARY FOR CODE TESTING
    @IBAction func hiddenPressed(_ sender: Any) {
        UIView.animate(withDuration: 1) {
            //constraint play
            self.bottomPrimaryConstraint.constant = -500
            self.bottomSecondaryConstraint.constant = -350
            //self.instructionViewPrimary.clueDescription.text = "Done"
            self.view.layoutIfNeeded()
        }
        coordinator?.toStory()
        if defaults.string(forKey: "userState") == "clear_story_1" {
            defaults.set("clear_explore_1", forKey: "userState")
        } else {
            defaults.set("clear_explore_2", forKey: "userState")
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Guideline Cards", bundle: Bundle.main)
            
        {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 2
            
            print("Image Succesfully Added")
        }
        
        arSCN.session.run(configuration)
        print("configuration ran")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        arSCN.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        DispatchQueue.main.async
        {
            if let imageAnchor = anchor as? ARImageAnchor
            {
                
                
                if imageAnchor.referenceImage.name == "blue-card" {
                    
                    let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                    
                    plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0)
                    
                    let planeNode = SCNNode(geometry: plane)
                    
                    planeNode.eulerAngles.x = -.pi / 2
                    
                    
                    self.blueCheckPointNode = planeNode
                    
                    node.addChildNode(planeNode)
                    
                    if let checkPointScene = SCNScene(named: "Models.scnassets/Checkpoint_blue.scn") {

                        if let checkPoint = checkPointScene.rootNode.childNodes.first {

                            checkPoint.eulerAngles.x = .pi / 2
                            
                            checkPoint.eulerAngles.z = .pi / 2

                            checkPoint.scale = SCNVector3(x: 3, y: 3, z: 3)

                            planeNode.addChildNode(checkPoint)
                        }
                    }
                }

                if imageAnchor.referenceImage.name == "green-card" {
                    
                    let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                    
                    plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0)
                    
                    let planeNode = SCNNode(geometry: plane)
                    
                    planeNode.eulerAngles.x = -.pi / 2
                    
                    
                    self.greenCheckPointNode = planeNode
                    
                    node.addChildNode(planeNode)
                    
                    if let checkPointScene = SCNScene(named: "Models.scnassets/Checkpoint_green.scn") {

                        if let checkPoint = checkPointScene.rootNode.childNodes.first {
                            
                            checkPoint.eulerAngles.x = .pi / 2

                            checkPoint.scale = SCNVector3(x: 3, y: 3, z: 3)

                            planeNode.addChildNode(checkPoint)
                        }
                    }
                }
                
                if imageAnchor.referenceImage.name == "red-card" {
                    
                    let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                    
                    plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0)
                    
                    let planeNode = SCNNode(geometry: plane)
                    
                    planeNode.eulerAngles.x = -.pi / 2
                    
                    
                    self.redCheckPointNode = planeNode
                    
                    node.addChildNode(planeNode)
                    
                    if let checkPointScene = SCNScene(named: "Models.scnassets/Checkpoint_red.scn") {

                        if let checkPoint = checkPointScene.rootNode.childNodes.first {

                            checkPoint.eulerAngles.x = .pi / 2

                            checkPoint.scale = SCNVector3(x: 3, y: 3, z: 3)

                            planeNode.addChildNode(checkPoint)
                        }
                    }
                }
                
                
    //
    //            if imageAnchor.referenceImage.name == "seraung-card" {
    //
    //                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
    //
    //                plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
    //
    //                let planeNode = SCNNode(geometry: plane)
    //
    //                planeNode.eulerAngles.x = -.pi / 2
    //
    //
    //                self.seraungNode = planeNode
    //
    //                node.addChildNode(planeNode)
    //
    //                if let checkPointScene = SCNScene(named: "Models.scnassets/seraung.scn") {
    //
    //                    if let checkPoint = checkPointScene.rootNode.childNodes.first {
    //
    //                        checkPoint.eulerAngles.x = .pi / 2
    //
    //                        planeNode.addChildNode(checkPoint)
    //                    }
    //                }
    //            }
    //
    //
                if imageAnchor.referenceImage.name == "tarumpah-card" {
    
                    let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
    
                    plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
    
                    let planeNode = SCNNode(geometry: plane)
    
                    planeNode.eulerAngles.x = -.pi / 2
    
    
                    self.tarumpahNode = planeNode
    
                    node.addChildNode(planeNode)
    
                    if let checkPointScene = SCNScene(named: "Models.scnassets/tarumpah.scn") {
    
                        if let checkPoint = checkPointScene.rootNode.childNodes.first {
    
                            checkPoint.eulerAngles.x = .pi / 2
                            
                            checkPoint.scale = SCNVector3(x: 3, y: 3, z: 3)
    
                            planeNode.addChildNode(checkPoint)
                        }
                    }
                }
    
    //
    //            if imageAnchor.referenceImage.name == "tinim-card" {
    //
    //                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
    //
    //                plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
    //
    //                let planeNode = SCNNode(geometry: plane)
    //
    //                planeNode.eulerAngles.x = -.pi / 2
    //
    //
    //                self.tinimiNode = planeNode
    //
    //                node.addChildNode(planeNode)
    //
    //                if let checkPointScene = SCNScene(named: "Models.scnassets/tinim.scn") {
    //
    //                    if let checkPoint = checkPointScene.rootNode.childNodes.first {
    //
    //                        checkPoint.eulerAngles.x = .pi / 2
    //
    //                        planeNode.addChildNode(checkPoint)
    //                    }
    //                }
    //            }
    //
    //            if imageAnchor.referenceImage.name == "lontong-card" {
    //
    //                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
    //
    //                plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
    //
    //                let planeNode = SCNNode(geometry: plane)
    //
    //                planeNode.eulerAngles.x = -.pi / 2
    //
    //
    //                self.lontongNode = planeNode
    //
    //                node.addChildNode(planeNode)
    //
    //                if let checkPointScene = SCNScene(named: "Models.scnassets/lontong.scn") {
    //
    //                    if let checkPoint = checkPointScene.rootNode.childNodes.first {
    //
    //                        checkPoint.eulerAngles.x = .pi / 2
    //
    //                        planeNode.addChildNode(checkPoint)
    //                    }
    //                }
    //            }
    //
                
                
                
                
            }
        }
        
        return node
    }
    
    @objc
        func homeTapped() {
            coordinator?.toLanding()
            AudioSFXPlayer.shared.playCommonSFX()
            Sound.stopAll()
        }
    
    func setUpAutoLayout() {
        
        NSLayoutConstraint.activate([
            homeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            homeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as! UITouch
        
        if (touch.view == self.arSCN)
        {
            print("Is Touching")
            let viewTouchLocation:CGPoint = touch.location(in: arSCN)
            guard let result = arSCN.hitTest(viewTouchLocation, options: nil).first else {
                return
            }
            if let planeNode = blueCheckPointNode, planeNode == result.node {
                coordinator?.toStory()
                defaults.set("clear_explore_1", forKey: "userState")
            }
            
            if let planeNode = greenCheckPointNode, planeNode == result.node {
                print("Green")
                coordinator?.toStory()
                defaults.set("clear_explore_2", forKey: "userState")
            }
            
            if let planeNode = redCheckPointNode, planeNode == result.node {
                print("Red")
                coordinator?.toStory()
                defaults.set("clear_explore_3", forKey: "userState")
            }
            
            if let planeNode = seraungNode, planeNode == result.node {
                collectionViewModel.obtainItem(index: 0)
                
                
                //MARK: Open Get Pop Up
            }
//
            if let planeNode = tarumpahNode, planeNode == result.node {
                
                collectionViewModel.obtainItem(index: 1)
                
                //MARK: Open Get Pop Up
            }

            if let planeNode = tinimiNode, planeNode == result.node {
                collectionViewModel.obtainItem(index: 2)
                
                
                //MARK: Open Get Pop Up
            }

            if let planeNode = lontongNode, planeNode == result.node {
                collectionViewModel.obtainItem(index: 3)
                
                
                //MARK: Open Get Pop Up
            }

        }
    }
}
