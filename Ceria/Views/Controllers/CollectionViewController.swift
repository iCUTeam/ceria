//
//  CollectionViewController.swift
//  Ceria
//
//  Created by Kathleen Febiola on 12/10/22.
//

import UIKit
import SceneKit

class CollectionViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    private let collectionSceneView: SCNView =
    {
        let scnView = SCNView()
        let scene = SCNScene(named: "Models.scnassets/CollectionScene.scn")
        scnView.allowsCameraControl = false
        scnView.scene = scene
        
        return scnView
    }()
    
    
    private lazy var homeButton: MakeButton = {
        let button = MakeButton(image: "home.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: MakeButton =
    {
        let button = MakeButton(image: "x.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    private var collectionItem: CollectionItem!
    
    let viewModel = CollectionViewModel()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.string(forKey: "userState") == nil
        {
            viewModel.initializeCollection()
        }
        
        view.addSubview(collectionSceneView)
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        let x: CGFloat
        let y: CGFloat
        let w: CGFloat
        let h: CGFloat
        
        if screenWidth == 834.0 {
            x = 65
            y = 150
            w = 700
            h = 1000
        } else {
            x = 160
            y = 200
            w = 700
            h = 1000
        }
    
        collectionItem = CollectionItem(frame: CGRect(x: x, y: y, width: w, height: h))
        collectionItem.roundCornerView(corners: .allCorners, radius: 30)
        view.addSubview(collectionItem)
        view.addSubview(homeButton)
    
        view.addSubview(closeButton)
        
        collectionItem.isHidden = true
        closeButton.isHidden = true
        
        setUpAutoLayout()
        setupNode()
        
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.numberOfTapsRequired = 1
        
        tapRecognizer.addTarget(self, action: #selector(tapObject(recognizer:)))
        
        collectionSceneView.addGestureRecognizer(tapRecognizer)
        //Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionSceneView.frame = view.bounds
    }
    
    @objc func tapObject(recognizer: UITapGestureRecognizer)
    {
        let location = recognizer.location(in: collectionSceneView)
        let hitResults = collectionSceneView.hitTest(location)
        
        if hitResults.count > 0
        {
            let result = hitResults.first
            if let node = result?.node
            {
                for x in 0..<4
                {
                    if node.name == "\(x)-unlocked"
                    {
                        AudioSFXPlayer.shared.playCommonSFX()
                        setupPopUP(index: x, isUnlocked: true)
                        
                        UIView.animate(withDuration: 2) {
                            self.collectionItem.isHidden = false
                            self.closeButton.isHidden = false
                        }
                        
                        break
                    }
                    
                    else if node.name == "\(x)-locked"
                    {
                        AudioSFXPlayer.shared.playCommonSFX()
                        setupPopUP(index: x, isUnlocked: false)
                        
                        UIView.animate(withDuration: 2) {
                            self.collectionItem.isHidden = false
                            self.closeButton.isHidden = false
                        }
                        
                        break
                    }
                }
                
               
            }
        }
    }
    
    private func setupPopUP(index: Int, isUnlocked: Bool)
    {
        
        switch(isUnlocked)
        {
            case true:
            viewModel.getCollection(index: index)
            
            viewModel.collectibleName.bind { [weak self] name in
                self?.collectionItem.itemName.text = name
            }
            
            viewModel.collectibleOrigin.bind { [weak self] origin in
                self?.collectionItem.itemOrigin.text = origin
            }
            
            viewModel.collectibleDesc.bind { [weak self] desc in
                self?.collectionItem.itemDesc.text = desc
                self?.collectionItem.itemDesc.allowsEditingTextAttributes = false
            }
            
            viewModel.collectibleItem.bind { [weak self] item in
                self?.collectionItem.setSCNView(scn: "Models.scnassets/\(item)")
            }
            
//
//
            case false:
            viewModel.getCollection(index: index)
            
            collectionItem.itemName.text = "???"
            collectionItem.itemOrigin.text = "???"
            collectionItem.itemDesc.text = "\n\nIkuti cerita Tuappaka Sisarikbattang untuk menemukan benda tersembunyi ini ya."

            viewModel.collectibleLocked.bind { [weak self] item in
                self?.collectionItem.setSCNView(scn: "Models.scnassets/\(item)")
            }
        }
      
    }
    
    func setupNode()
    {
        var unlockedNodes: [SCNNode] = []
        
        var lockedNodes: [SCNNode] = []
        
        for x in 0..<4
        {
            unlockedNodes.append((collectionSceneView.scene?.rootNode.childNode(withName: "\(x)-unlocked", recursively: true))!)
            lockedNodes.append((collectionSceneView.scene?.rootNode.childNode(withName: "\(x)-locked", recursively: true))!)
            
            viewModel.getCollection(index: x)
            
            if viewModel.obtainedStatus[x]
            {
                unlockedNodes[x].isHidden = false
                lockedNodes[x].isHidden = true
            }
            
            else
            {
                unlockedNodes[x].isHidden = true
                lockedNodes[x].isHidden = false
            }
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc
        func homeTapped() {
            coordinator?.toLanding()
            AudioSFXPlayer.shared.playCommonSFX()
        }
    
    @objc func closeTapped()
    {
        collectionItem.isHidden = true
        closeButton.isHidden = true
        AudioSFXPlayer.shared.playBackSFX()
    }
    
    func setUpAutoLayout() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        let constant: CGFloat
        let constant2: CGFloat
        
        if screenWidth == 834.0 {
            constant = 100
            constant2 = 700
        } else {
            constant = 150
            constant2 = 800
        }
        
        NSLayoutConstraint.activate([
            homeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            homeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: constant),
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: constant2),
            
            collectionItem.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionItem.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
  

}
