//
//  ActivateViewController.swift
//  Ceria
//
//  Created by Kathleen Febiola Susanto on 12/10/22.
//

import UIKit
import PencilKit
import SwiftySound

class PowerViewController: UIViewController, PKCanvasViewDelegate, CALayerDelegate, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    private lazy var homeButton: MakeButton = {
        let button = MakeButton(image: "home.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: MakeButton = {
        let button = MakeButton(image: "next.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dialogueTextBox: PowerView = {
        let dialogue = PowerView(content: "Ikuti pola di atas untuk memilih seseorang dari keempat bersaudara yang akan menjemput tuan puteri dari tempat burung garuda.")
        return dialogue
    }()
    
    private let backgroundCanvasView: PKCanvasView =
    {
        let canvas = PKCanvasView()
        canvas.backgroundColor = .clear
        canvas.translatesAutoresizingMaskIntoConstraints = false
        return canvas
    }()
    
    private let canvasView: PKCanvasView =
    {
        let canvas = PKCanvasView()
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = .clear
        canvas.tool = PKInkingTool(.marker, color: .white, width: 70) // ubah warnanya stroke drawing
        canvas.translatesAutoresizingMaskIntoConstraints = false
        return canvas
    }()
    
    private lazy var powerSymbol: UIImageView = {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        let x: CGFloat
        let y: CGFloat
        let w: CGFloat
        let h: CGFloat
        
        if screenWidth == 834.0 {
            x = -10
            y = -10
            w = 850
            h = 1020
        } else {
            x = 15
            y = -15
            w = 1000
            h = 1200
        }
        
        let powerSymbol = UIImageView(frame: CGRect(x: x, y: y, width: w, height: h))
        powerSymbol.image = UIImage(named: "lompo_symbol.png")
        powerSymbol.contentMode = .scaleToFill
        return powerSymbol
    }()
    
    private lazy var hintButton: MakeButton = {
        let button = MakeButton(image: "Lompo.png", size: CGSize(width: 150, height: 150))
        button.addTarget(self, action: #selector(hintTapped), for: .touchUpInside)
        return button
    }()
    
    private let viewModel = PowerViewModel()
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    let defaults = UserDefaults.standard
    var powerHeadNormal = ""
    var powerHeadSuccess = ""
    var powerPattern = ""
    var patternEnum: shape = .eye
    var patternColor: UIColor = .green
    var powerIntroVoice = ""
    var powerHintVoice = ""
    var powerSuccessVoice = ""
    var powerSuccessText = ""
    var currentIndex = 0
    
    // Animation.
    static let repeatStrokeAnimationTime: TimeInterval = 4
    static let nextStrokeAnimationTime: TimeInterval = 0.5
    
    var animatingStroke: PKStroke?
    var animationMarkerLayer: CALayer!
    var animationStartMarkerLayer: CALayer!
    var animationParametricValue: CGFloat = 0
    var animationLastFrameTime = Date()
    var animationTimer: Timer?
    var isSuccess: Bool = false
    
    var patternGenerator = PatternGenerator()
    
    var animationSpeed: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.contentMode = .scaleToFill
        view.insertSubview(backgroundImage, at: 0)
        
        view.addSubview(powerSymbol)
        
        view.addSubview(hintButton)
        
        view.addSubview(backgroundCanvasView)
        view.addSubview(canvasView)
        
        view.addSubview(dialogueTextBox)
        view.addSubview(homeButton)
        view.addSubview(nextButton)
        setUpAutoLayout()
        
        setupBinders()
        
        viewModel.loadPower()
        initialButtonChange()
        
        animationMarkerLayer = CALayer()
        animationMarkerLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.1, height: view.frame.width * 0.1)
        choosePatternColor()
        animationMarkerLayer.backgroundColor = patternColor.cgColor
        animationMarkerLayer.cornerRadius = view.frame.width * 0.05
        animationMarkerLayer.delegate = self
        backgroundCanvasView.layer.addSublayer(animationMarkerLayer)
        
        animationStartMarkerLayer = CALayer()
        animationStartMarkerLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.1, height: view.frame.width * 0.1)
        choosePatternColor()
        animationStartMarkerLayer.borderColor = patternColor.cgColor
        animationStartMarkerLayer.borderWidth = view.frame.width * 0.01
        animationStartMarkerLayer.cornerRadius = view.frame.width * 0.05
        animationStartMarkerLayer.delegate = self
        backgroundCanvasView.layer.addSublayer(animationStartMarkerLayer)
        
        canvasView.delegate = self
        
        nextButton.isHidden = true
        Sound.stopAll()
        setBGMPower()
        Sound.play(file: powerIntroVoice)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        let x: CGFloat
        let y: CGFloat
        let w: CGFloat
        let h: CGFloat
        
        if screenWidth <= 834.0 {
            x = -90
            y = -120
            w = 1020
            h = 1190
        } else {
            x = -100
            y = -150
            w = 1200
            h = 1400
        }
        
        backgroundCanvasView.frame = CGRect(x: x, y: y, width: w, height: h)
        canvasView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        switch powerHeadNormal {
        case "Lompo":
            patternEnum = .eye
        case "Rua":
            patternEnum = .flash
        case "Tallu":
            patternEnum = .arrow
        default:
            patternEnum = .hammer
        }
        
        patternGenerator.dotsPoint = patternGenerator.setPoints(currentShape: patternEnum, frame: backgroundCanvasView.frame)
        backgroundCanvasView.drawing = patternGenerator.synthDrawing(frame: backgroundCanvasView.frame)
        
        animateNextStroke()
        
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
    
    private func setupBinders() {
        viewModel.powerHeadNormal.bind { [weak self] head in
            self?.powerHeadNormal = head
        }
        
        viewModel.powerHeadSuccess.bind { [weak self] head in
            self?.powerHeadSuccess = head
        }
        
        viewModel.powerHintText.bind { [weak self] hint in
            self?.dialogueTextBox.titleLabel.text = "Petunjuk:"
            self?.dialogueTextBox.dialogueLabel.text = hint
        }
        
        viewModel.powerSuccessText.bind { [weak self] success in
            self?.powerSuccessText = success
        }
        
        viewModel.powerIntroVoice.bind { [weak self] voice in
            self?.powerIntroVoice = voice
        }
        
        viewModel.powerHintVoice.bind { [weak self] voice in
            self?.powerHintVoice = voice
        }
        
        viewModel.powerSuccessVoice.bind { [weak self] voice in
            self?.powerSuccessVoice = voice
        }
        
        viewModel.powerPatternImage.bind { [weak self] image in
            self?.powerSymbol.image = UIImage(named: image)
        }
        
        viewModel.powerBackgroundImage.bind { [weak self] image in
            self?.backgroundImage.image = UIImage(named: image)
        }
        
        viewModel.powerPatternReference.bind { [weak self] pattern in
            self?.powerPattern = pattern
        }
        
        viewModel.currentIndex.bind { [weak self] index in
            self?.currentIndex = index
        }
    }
    
    //MARK: Step Animation
    
    @objc
    func homeTapped() {
        coordinator?.toLanding()
        AudioSFXPlayer.shared.playCommonSFX()
        Sound.stopAll()
        AudioBGMPlayer.shared.stopStoryBGM()
    }
    
    @objc
    func hintTapped() {
        
        if isSuccess == false {
            Sound.stopAll()
            Sound.play(file: powerHintVoice)
        } else {
            Sound.play(file: "")
        }
    }
    
    @objc
    func nextTapped() {
        Sound.stopAll()
        
        switch defaults.integer(forKey: "powerIndex") {
        case 1:
            coordinator?.toTutorial()
        default:
            coordinator?.toSuccess()
        }
    }
    
    func setBGMPower() {
        switch powerHeadNormal {
        case "Lompo":
            AudioBGMPlayer.shared.playStoryBGM3()
        case "Rua":
            AudioBGMPlayer.shared.playStoryBGM8()
        case "Tallu":
            AudioBGMPlayer.shared.playStoryBGM7()
        default:
            AudioBGMPlayer.shared.playStoryBGM10()
        }
    }
    
    func initialButtonChange() {
        let customButtonImage = UIImage(named: powerHeadNormal)
        let newimage = customButtonImage?.resizedImage(size: CGSize(width: 150, height: 150))
        hintButton.setImage(newimage, for: .normal)
        hintButton.contentMode = .scaleAspectFit
    }
    
    func applySuccessChange() {
        let customButtonImage = UIImage(named: powerHeadSuccess)
        let newimage = customButtonImage?.resizedImage(size: CGSize(width: 150, height: 150))
        hintButton.setImage(newimage, for: .normal)
        hintButton.contentMode = .scaleAspectFit
        
        isSuccess = true
        
        nextButton.isHidden = false
        
        dialogueTextBox.titleLabel.text = "\(powerHeadNormal):"
        dialogueTextBox.dialogueLabel.text = powerSuccessText
    }
    
    func setUpAutoLayout() {
        
        NSLayoutConstraint.activate([
            homeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            homeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
            hintButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            hintButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            
            dialogueTextBox.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -170),
            dialogueTextBox.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 95),
            dialogueTextBox.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 24),
            //dialogueTextBox.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            backgroundCanvasView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundCanvasView.topAnchor.constraint(equalTo: view.topAnchor, constant: 500),
            canvasView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            canvasView.topAnchor.constraint(equalTo: view.topAnchor, constant: 500)
        ])
    }
    
    func animateNextStroke() {
        
        let nextStrokeIndex = canvasView.drawing.strokes.count
        guard nextStrokeIndex < backgroundCanvasView.drawing.strokes.count else {
            // Hide the animation markers.
            animationMarkerLayer.opacity = 0.0
            animationStartMarkerLayer.opacity = 0.0
            return
        }
        
        let strokeToAnimate = backgroundCanvasView.drawing.strokes[nextStrokeIndex]
        animatingStroke = strokeToAnimate
        animationParametricValue = 0
        animationLastFrameTime = Date()
        animationTimer?.invalidate()
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60, repeats: true) { _ in self.stepAnimation() }
        
        // Setup the start marker layer.
        animationStartMarkerLayer.position = patternGenerator.dotsPoint.first ?? CGPoint(x: backgroundCanvasView.frame.width * 0.7, y: backgroundCanvasView.frame.width * 0.2)
        animationStartMarkerLayer.opacity = 1.0
    }
    
    func startAnimation(afterDelay delay: TimeInterval) {
        // Animate the next stroke again after `delay`.
        stopAnimation()
        animationTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            // Only animate the next stroke if another animation has not already started.
            if self.animatingStroke == nil {
                self.animateNextStroke()
            }
        }
    }
    
    func stopAnimation() {
        animationMarkerLayer.opacity = 0
        animatingStroke = nil
        animationTimer?.invalidate()
    }
    
    func stepAnimation() {
        guard let animatingStroke = animatingStroke, animationParametricValue < CGFloat(animatingStroke.path.count - 1) else {
            // Animate the next stroke again, in `repeatStrokeAnimationTime` seconds.
            startAnimation(afterDelay: PowerViewController.repeatStrokeAnimationTime)
            return
        }
        
        let currentTime = Date()
        let delta = currentTime.timeIntervalSince(animationLastFrameTime)
        animationParametricValue = animatingStroke.path.parametricValue(
            animationParametricValue,
            offsetBy: .time(delta * TimeInterval(animationSpeed)))
        animationMarkerLayer.position = patternGenerator.dotsPoint.first ?? CGPoint(x: backgroundCanvasView.frame.width * 0.7, y: backgroundCanvasView.frame.width * 0.2)
        
        print(animationMarkerLayer.position)
        animationMarkerLayer.opacity = 1
        animationLastFrameTime = currentTime
    }
    
    var isUpdatingDrawing = false
    
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        // Stop any animation as soon as the user begins to draw.
        stopAnimation()
        animationStartMarkerLayer.opacity = 0.0
    }
    
    func choosePatternColor() {
        switch powerHeadNormal {
        case "Lompo":
            patternColor = .init(red: 209/255, green: 100/255, blue: 100/255, alpha: 1)
        case "Rua":
            patternColor = .init(red: 255/255, green: 196/255, blue: 0/255, alpha: 1)
        case "Tallu":
            patternColor = .init(red: 100/255, green: 196/255, blue: 116/255, alpha: 1)
        default:
            patternColor = .init(red: 5/255, green: 180/255, blue: 255/255, alpha: 1)
        }
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        // Avoid triggering the scoring, if we are programatically mutating the drawing.
        guard !isUpdatingDrawing else { return }
        
        let testDrawing = backgroundCanvasView.drawing
        let strokeIndex = canvasView.drawing.strokes.count - 1
        
        // Score the last stroke.
        guard let lastStroke = canvasView.drawing.strokes.last else { return }
        guard strokeIndex < testDrawing.strokes.count else { return }
        
        isUpdatingDrawing = true
        
        let distance = lastStroke.discreteFrechetDistance(to: testDrawing.strokes[strokeIndex], maxThreshold: 5)
        
        print(distance)
        if distance < 20 {
            // Adjust the correct stroke to have a green ink.
            choosePatternColor()
            canvasView.drawing.strokes[strokeIndex].ink.color = patternColor // ubah warnanya stroke correct
            canvasView.tool = PKInkingTool(.marker, color: .clear, width: 70)
            Sound.stopAll()
            Sound.play(file: "power_success.wav")
            applySuccessChange()
            
            backgroundCanvasView.drawing.strokes[strokeIndex].ink.color = .clear
            Sound.play(file: powerSuccessVoice)
            
            
            //            AudioBGMPlayer.shared.playStoryBGM1()
            //MARK: In 3 second, move to next page
        } else {
            // If the stroke drawn was bad, remove it so the user can try again.
            Sound.play(file: "power_fail.m4a")
            canvasView.drawing.strokes.removeLast()
            
        }
        
        startAnimation(afterDelay: PowerViewController.nextStrokeAnimationTime)
        isUpdatingDrawing = false
    }
    
    
    
    
}
