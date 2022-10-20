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
    
    //checkpoint
    private lazy var dialogueTextBox: ExploreView = {
        let dialogue = ExploreView(content: hintText)
        return dialogue
    }()
    
    //collectibles
    private lazy var dialogueTextBox2: ExploreView = {
        let dialogue = ExploreView(content: hintText2)
        return dialogue
    }()
    
    //checkpoint
    private lazy var hintButton: MakeButton = {
        let button = MakeButton(image: hintImage, size: CGSize(width: 115, height: 150))
        button.addTarget(self, action: #selector(hintTapped), for: .touchUpInside)
        return button
    }()
    
    //collectibles
    private lazy var hint2Button: MakeButton = {
        let button = MakeButton(image: hintImage2, size: CGSize(width: 115,  height: 150))
        button.addTarget(self, action: #selector(hint2Tapped), for: .touchUpInside)
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
    
    var hint: String = ""
    var hint2: String = ""
    var hintText: String = ""
    var hintText2: String = ""
    var hintImage: String = ""
    var hintImage2: String = ""
    
    private let collectionViewModel = CollectionViewModel()
    
    private var collectionItem: CollectionItem!
    
    private lazy var closeButton: MakeButton =
    {
        let button = MakeButton(image: "x.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionItem = CollectionItem(frame: CGRect(x: view.frame.width * 0.125, y: view.frame.height * 0.1, width: 800, height: 1100))
        collectionItem.roundCornerView(corners: .allCorners, radius: 30)
        view.addSubview(collectionItem)
        view.addSubview(homeButton)
        
        view.addSubview(hintButton)
        view.addSubview(hint2Button)
        view.addSubview(dialogueTextBox)
        view.addSubview(dialogueTextBox2)
        
        view.addSubview(closeButton)
        
        collectionItem.isHidden = true
        closeButton.isHidden = true
        
        setUpAutoLayout()
        
        // Set the view's delegate
        arSCN.delegate = self
        
        // Show statistics such as fps and timing information
        arSCN.showsStatistics = false
        
        arSCN.autoenablesDefaultLighting = true
        
        //set primary clue data
//        instructionViewPrimary.clueDescription.text = getDescClue(clueCode: 1)
//        instructionViewPrimary.clueGreyBackView.layer.cornerRadius = 20
//        instructionViewPrimary.clueImage.image = UIImage(named: "red-card")
        
        //set second clue data
//        instructionViewSecondary.clueDescription.text = getDescClue(clueCode: 2)
//        instructionViewSecondary.clueGreyBackView.layer.cornerRadius = 20
//        instructionViewSecondary.clueImage.image = UIImage(named: "blue-card")
        
        
        if defaults.string(forKey: "userState") == "clear_story_1" {
            Sound.play(file: "explore2-intro.m4a")
            
            hint = "explore2_hint.m4a"
            hint2 = ""
            
            dialogueTextBox.dialogueLabel.text = "Cari kartu dengan gambar pulau di sekitarmu untuk membantu kapal berlabuh ke pulau yang tepat."
            
            let customButtonImage = UIImage(named:  "kartu_pulau")
            let newimage = customButtonImage?.resizedImage(size: CGSize(width: 115, height: 150))
            hintButton.setImage(newimage, for: .normal)
            
            hint2Button.isHidden = true
            dialogueTextBox2.isHidden = true
            
        } else {
            Sound.play(file: "tallu_explore3.m4a")
            
            hint = "explore3_hint.m4a"
            hint2 = "explore3_collect_hint.m4a"
            
            dialogueTextBox.dialogueLabel.text = "Cari kartu dengan gambar kapal di sekitarmu untuk membantu Rua dan tuan puteri kembali ke kapal."
            dialogueTextBox2.dialogueLabel.text = "Cari kartu bergambar wajah Rua sebelum cerita usai untuk mengambil hadiah dari Rua ya."
            
            let customButtonImage = UIImage(named:  "kartu_kapal")
            let newimage = customButtonImage?.resizedImage(size: CGSize(width: 115, height: 150))
            hintButton.setImage(newimage, for: .normal)
            
            let customButtonImage2 = UIImage(named:  "kartu_rua")
            let newimage2 = customButtonImage2?.resizedImage(size: CGSize(width: 115, height: 150))
            hint2Button.setImage(newimage2, for: .normal)
            
            hint2Button.isHidden = false
            dialogueTextBox2.isHidden = false
        }
        
        if collectionViewModel.obtainedStatus.count == 0
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
        sleep(3)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Guideline Cards", bundle: Bundle.main)
            
        {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 1
            
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
                
                
                if imageAnchor.referenceImage.name == "kartu_pulau" {
                    
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

                if imageAnchor.referenceImage.name == "kartu_kapal" {
                    
                    let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                    
                    plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0)
                    
                    let planeNode = SCNNode(geometry: plane)
                    
                    planeNode.eulerAngles.x = -.pi / 2
                    
                    
                    self.greenCheckPointNode = planeNode
                    
                    node.addChildNode(planeNode)
                    
                    if let checkPointScene = SCNScene(named: "Models.scnassets/Checkpoint_green.scn") {

                        if let checkPoint = checkPointScene.rootNode.childNodes.first {
                            
                            checkPoint.eulerAngles.x = .pi / 2
                            
                            checkPoint.eulerAngles.z = .pi / 2

                            checkPoint.scale = SCNVector3(x: 3, y: 3, z: 3)

                            planeNode.addChildNode(checkPoint)
                        }
                    }
                }
                
//                if imageAnchor.referenceImage.name == "kartu_istana" {
//
//                    let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
//
//                    plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0)
//
//                    let planeNode = SCNNode(geometry: plane)
//
//                    planeNode.eulerAngles.x = -.pi / 2
//
//
//                    self.redCheckPointNode = planeNode
//
//                    node.addChildNode(planeNode)
//
//                    if let checkPointScene = SCNScene(named: "Models.scnassets/Checkpoint_red.scn") {
//
//                        if let checkPoint = checkPointScene.rootNode.childNodes.first {
//
//                            checkPoint.eulerAngles.x = .pi / 2
//
//                            checkPoint.scale = SCNVector3(x: 3, y: 3, z: 3)
//
//                            planeNode.addChildNode(checkPoint)
//                        }
//                    }
//                }
                
                
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
                if imageAnchor.referenceImage.name == "kartu_rua" {
    
                    let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
    
                    plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
    
                    let planeNode = SCNNode(geometry: plane)
    
                    planeNode.eulerAngles.x = -.pi / 2
    
    
                    self.tarumpahNode = planeNode
    
                    node.addChildNode(planeNode)
    
                    if let checkPointScene = SCNScene(named: "Models.scnassets/Treasure_chest.scn") {
    
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
    
    @objc func closeTapped()
    {
        collectionItem.isHidden = true
        closeButton.isHidden = true
        AudioSFXPlayer.shared.playBackSFX()
    }
    
    @objc
    func hintTapped() {
        Sound.play(file: hint)
    }
    
    @objc
    func hint2Tapped() {
        Sound.play(file: hint2)
    }
    
    
    func setUpAutoLayout() {
        
        NSLayoutConstraint.activate([
            homeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            homeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 875),
            
            hint2Button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -190),
            hint2Button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            hintButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            hintButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            dialogueTextBox2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -340),
            dialogueTextBox2.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 95),
            dialogueTextBox2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 24),
            
            dialogueTextBox.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -170),
            dialogueTextBox.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 95),
            dialogueTextBox.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 24),
        ])
    }
    
    private func setupPopUP(index: Int)
    {
        
            collectionViewModel.getCollection(index: index)
        
            collectionItem.isHidden = false
            closeButton.isHidden = false
            
            collectionViewModel.collectibleName.bind { [weak self] name in
                self?.collectionItem.itemName.text = name
            }
            
            collectionViewModel.collectibleOrigin.bind { [weak self] origin in
                self?.collectionItem.itemOrigin.text = origin
            }
            
            collectionViewModel.collectibleDesc.bind { [weak self] desc in
                self?.collectionItem.itemDesc.text = "Asik! Kamu menemukan hadiah dari Rua! Kamu bisa menemukan item ini di rak koleksi kamu, ya!"
                self?.collectionItem.itemDesc.allowsEditingTextAttributes = false
            }
            
            collectionViewModel.collectibleItem.bind { [weak self] item in
                self?.collectionItem.setSCNView(scn: "Models.scnassets/\(item)")
            }
        
       
      
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
                Sound.play(file: "checkpoint_found.m4a")
                
                //Sound.play(file:"explore2_found.m4a")
            }
            
            if let planeNode = greenCheckPointNode, planeNode == result.node {
                coordinator?.toStory()
                defaults.set("clear_explore_2", forKey: "userState")
                Sound.play(file: "checkpoint_found.m4a")
                
                //Sound.play(file:"explore3_found.m4a")
            }
            
            if let planeNode = redCheckPointNode, planeNode == result.node {
                coordinator?.toStory()
                defaults.set("clear_explore_3", forKey: "userState")
                Sound.play(file: "checkpoint_found.m4a")
            }
            
            if let planeNode = seraungNode, planeNode == result.node {
                collectionViewModel.obtainItem(index: 0)
                setupPopUP(index: 0)
                Sound.play(file: "checkpoint_clicked.m4a")
            }
//
            if let planeNode = tarumpahNode, planeNode == result.node {
                
                collectionViewModel.obtainItem(index: 1)
                setupPopUP(index: 1)
                Sound.play(file: "checkpoint_clicked.m4a")
                
                //Sound.play(file:"explore3_collect_found.m4a")
            }

            if let planeNode = tinimiNode, planeNode == result.node {
                collectionViewModel.obtainItem(index: 2)
                setupPopUP(index: 2)
                Sound.play(file: "checkpoint_clicked.m4a")
            }

            if let planeNode = lontongNode, planeNode == result.node {
                collectionViewModel.obtainItem(index: 3)
                setupPopUP(index: 3)
                Sound.play(file: "checkpoint_clicked.m4a")
            }

        }
    }
}
