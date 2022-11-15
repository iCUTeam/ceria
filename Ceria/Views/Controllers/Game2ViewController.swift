//
//  Game2ViewController.swift
//  icu
//
//  Created by Kathleen Febiola Susanto on 04/10/22.
//

import UIKit
import SceneKit
import SwiftySound

class Game2ViewController: UIViewController, SCNSceneRendererDelegate, SCNPhysicsContactDelegate, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var powerProgressBar: HorizontalProgressBar!
    @IBOutlet weak var sceneView: SCNView!
    
    private lazy var homeButton: MakeButton = {
        let button = MakeButton(image: "home.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        return button
    }()
    
    //collision bitmask
    let categoryObstacles = 2
    
    weak var scene: SCNScene!
    
    var gameStarted = false
    var lifeTotal: Int = 1000
    
    weak var crashNode: SCNNode!
    weak var selfieNode: SCNNode!
    
    var initialPosition: SCNVector3!
    
    var motion = MotionHelper()
    var motionForce = SCNVector3(0,0,0)
    
    var immune = false
    
    let accelerationData: [Float] = [0.40, 0.50, 0.60, 0.70, 0.80, 0.90]
    
    var count = 0
    
    var index = 0
    
    var voiceName = ""
    
    var sounds:[String:SCNAudioSource] = [:]
    
    var ruaImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupNodes()
        setupOverlays()
        
        
        powerProgressBar.progress = 1
        
        view.addSubview(homeButton)
        setUpAutoLayout()
        
        AudioBGMPlayer.shared.playGame2BGM()
        
        Sound.stopAll()
        Sound.play(file: "rua_game_1.m4a")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.removeFromParent()
        self.navigationController?.popViewController(animated: false)
        self.navigationController?.presentedViewController?.dismiss(animated: false, completion: nil)
    }
    
    @objc
    func homeTapped() {
        coordinator?.toLanding()
        AudioSFXPlayer.shared.playCommonSFX()
        Sound.stopAll()
        AudioBGMPlayer.shared.stopGameBGM()
    }
    
    func setupOverlays() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        let x: CGFloat
        let y: CGFloat
        let x2: CGFloat
        let y2: CGFloat
        let x3: CGFloat
        let y3: CGFloat
        let w: CGFloat
        let h: CGFloat
        
        if screenWidth <= 834.0 {
            x = 150
            y = 30
            
            x2 = 720
            y2 = 30
            
            x3 = 200
            y3 = 80
            
            w = 600
            h = 10
        } else {
            x = 150
            y = 30
            
            x2 = 900
            y2 = 30
            
            x3 = 200
            y3 = 80
            
            w = 760
            h = 10
        }
        
        ruaImage = UIImageView(frame: CGRect(x: x, y: y, width: 100, height: 100))
        ruaImage.image = UIImage(named: "rua.png")
        ruaImage.contentMode = .scaleAspectFit
        view.insertSubview(ruaImage, at: 1)
        
        let puteriImage = UIImageView(frame: CGRect(x: x2, y: y2, width: 100, height: 100))
        puteriImage.image = UIImage(named: "putri.png")
        puteriImage.contentMode = .scaleAspectFit
        view.insertSubview(puteriImage, at: 1)
        
        let lineImage = UIImageView(frame: CGRect(x: x3, y: y3, width: w, height: h))
        lineImage.image = UIImage(named: "line.png")
        lineImage.contentMode = .scaleAspectFit
        view.insertSubview(lineImage, at: 1)
        
    }
    
    
    
    func setUpAutoLayout() {
        
        NSLayoutConstraint.activate([
            homeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            homeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
        ])
    }
    
    //manggil scene dan set delegate
    func setupScene()
    {
        //        sceneView = self.view as? SCNView
        sceneView.delegate = self
        sceneView.allowsCameraControl = false
        scene = SCNScene(named: "Models.scnassets/Game Rua/Game2.scn")
        sceneView.scene = scene
        sceneView.frame = view.bounds
        
        scene.physicsWorld.contactDelegate = self
        
        //add tap recognizer (tap gesture)
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        
        tapRecognizer.addTarget(self, action: #selector(Game2ViewController.startPauseGame(recognizer:)))
        sceneView.addGestureRecognizer(tapRecognizer)
        
    }
    
    //set nodes dari yang ada didalem scene yang dipanggil (cari node dengan nama yang diset recursively jadi bisa dpt lebih dari satu asal punya nama yang sama mereka termasuk satu node itu)
    func setupNodes()
    {
        crashNode = scene.rootNode.childNode(withName: "crash", recursively: true)!
        initialPosition = crashNode.position
        crashNode.physicsBody?.contactTestBitMask = categoryObstacles
        selfieNode = scene.rootNode.childNode(withName: "selfie-stick", recursively: true)!
    }
    
    
    //hide status bar wktu gameplay
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //klo memorynya dah berat nanti mereka release frame cache
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //fungsi buat start dan pause the game
    @objc func startPauseGame(recognizer: UITapGestureRecognizer)
    {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        let increment: CGFloat
        
        if screenWidth == 834.0 {
            increment = 1.1
        } else {
            increment = 1.5
        }
        
        count = 0
        
        Sound.play(file: "walk.m4a", numberOfLoops: -1)
        
        gameStarted.toggle()
        
        //cek klo game start dia mulai jalanin objectnya sesuai accelerationdata yang diatas per sumbu x dan z nya ngikut dari pergerakan accelerometer
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            
            if self.gameStarted
            {
                DispatchQueue.main.async {
                    self.motion.getAccelerometerData{ (x, y, z) in
                        
                        if self.crashNode.position.z > -12 && self.crashNode.position.z < 12
                        {
                            self.crashNode.position += SCNVector3(x: self.accelerationData[self.index], y: 0, z: x * 0.50)
                        }
                        
                        else if self.crashNode.position.z <= -12 && x > 0
                        {
                            self.crashNode.position += SCNVector3(x: self.accelerationData[self.index], y: 0, z: x * 0.50)
                        }
                        
                        else if self.crashNode.position.z >= 12 && x < 0
                        {
                            self.crashNode.position += SCNVector3(x: self.accelerationData[self.index], y: 0, z: x * 0.50)
                        }
                        
                        else
                            
                        {
                            self.crashNode.position += SCNVector3(x: self.accelerationData[self.index], y: 0, z: 0)
                        }
                       
                        
                    }
                    
                    
                    //timernya kan jalan 0.1 detik sekali, jadi itungannya 10 detik tu berarti dah jalan 100 hitungan
                    self.count += 1
                    
                    UIView.animate(withDuration: 0.1) {
                        self.ruaImage.layer.position.x += increment
                    }
                    
                    
                    //that's why klo countnya dia = 100 nanti kita tambahin index accelerationnya biar ambil next acceleration yang lebih cepet terus kita balik lagi count dari 0
                    if self.count % 100 == 0
                    {
                        self.index+=1
                        self.count = 0
                    }
                    
                    //
                    //validasi kalau sudah sampe finish
                    if self.crashNode.position.x >= 280 && self.crashNode.position.y <= 6 && self.crashNode.position.y >= -6
                    {
                        
                        Sound.play(file: "finish.wav")
                        Sound.play(file: "rua_game_2.m4a")
                        
                        
                        timer.invalidate()
                        sleep(2)
                        self.coordinator?.toSuccess()
                        Sound.stopAll()
                        AudioBGMPlayer.shared.stopGameBGM()
                        
                        
                        
                        //temporary alert
                        //                        let alert = UIAlertController(title: "Kamu berhasil!", message: "Asik, kita sudah sampai ke sarang Garuda! Ayo selamatkan tuan putri!", preferredStyle: .alert)
                        //
                        //                        alert.addAction(UIAlertAction(title: "Asik", style: .default)
                        //                        {_ in
                        //                            alert.dismiss(animated: true)
                        //
                        //                        })
                        //
                        //                        self.present(alert, animated: true)
                        
                        
                    }
                }
            }
            
            //kalau gamenya dipause kita stop timernya biar ga bisa jalan kemana-mana
            
            else
            {
                timer.invalidate()
                Sound.stop(file: "walk.m4a")
            }
        }
        
        
    }
    
    //fungsi buat update view per frame
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let crash = crashNode.presentation
        let crashing = crash.position
        
        
        //make camera follow object based on targeted position per frame (using selfie node yang ditaruh dibawah object yang difollow)
        let targetPosition = SCNVector3(x: crashing.x - 3, y: crashing.y + 2, z:crashing.z )
        var cameraPosition = selfieNode.position
        
        let camDamping:Float = 0.3
        
        let xComponent = cameraPosition.x * (1 - camDamping) + targetPosition.x * camDamping
        let yComponent = cameraPosition.y * (1 - camDamping) + targetPosition.y * camDamping
        let zComponent = cameraPosition.z * (1 - camDamping) + targetPosition.z * camDamping
        
        cameraPosition = SCNVector3(x: xComponent, y: yComponent, z: zComponent)
        selfieNode.position = cameraPosition
        
    }
    
    //fungsi buat deteksi collision (tabrakan) antar object
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        var contactNode:SCNNode!
        
        if contact.nodeA.name == "crash" {
            contactNode = contact.nodeB
        }else{
            contactNode = contact.nodeA
        }
        
        //detect klo yang dicollide itu obstacles bukan pake bit mask
        if contactNode.physicsBody?.categoryBitMask == categoryObstacles {
            
            //cek dia immune atau engga sama kalau total lifenya masih ada or not
            if lifeTotal > 0 && !immune
            {
                print("crash")
                //kalau nabrak nodenya kita hide dan nyawa berkurang
                contactNode.isHidden = true
                lifeTotal -= 200
                
                DispatchQueue.main.async {
                    self.powerProgressBar.progress -= 0.2
                    Sound.play(file: "damage.m4a")
                }
                
                //klo dia nabrak, dia bakal immune for 5 second sebelum dia balik bisa nabrak lagi
                immune.toggle()
                
                var immuneCount = 0
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                    DispatchQueue.main.async {
                        immuneCount+=1
                        
                        if immuneCount == 5
                        {
                            self.immune.toggle()
                            timer.invalidate()
                            immuneCount = 0
                        }
                    }
                    
                    
                }
            }
            
            
            else if lifeTotal == 0
            {
                print("try again")
                contactNode.isHidden = true
                lifeTotal = 1000
                
                DispatchQueue.main.async {
                    self.powerProgressBar.progress = 1
                    Sound.play(file: "game2_fail.m4a")
                    self.crashNode.position = self.initialPosition
                    
                    UIView.animate(withDuration: 0.1) {
                        self.ruaImage.layer.position.x = 150
                    }
                    
                    self.index = 0
                    self.count = 0
                }
                
                
            }
            
            
            //setelah 2 second, nodenya akan ditampilin lagi
            let waitAction = SCNAction.wait(duration: 1)
            let unhideAction = SCNAction.run { (node) in
                node.isHidden = false
            }
            
            
            let actionSequence = SCNAction.sequence([waitAction, unhideAction])
            
            contactNode.runAction(actionSequence)
        }
    }
    
}
