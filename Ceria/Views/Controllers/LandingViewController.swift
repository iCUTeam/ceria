//
//  LandingViewController.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import UIKit

class LandingViewController: UIViewController, Storyboarded {
    
    private lazy var landingLogoImage: UIImageView = {
        let imageView = UIImageView()
        let firstImage = UIImage(named: "logo.png")
        let newImage = firstImage?.resizedImage(size: CGSize(width: 570, height: 330))
        imageView.image = newImage
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let landingTextView = LandingView()
    
    private lazy var collectionButton: MakeButton = {
        let button = MakeButton(image: "collection.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(collectionTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var aboutButton: MakeButton = {
        let button = MakeButton(image: "about.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(aboutTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var landingButtonStackView: MakeStack = {
        let stackV = MakeStack(spacingValue: 0, subView: [collectionButton, aboutButton], axisValue: .horizontal, distributionValue: .equalSpacing)
        return stackV
    }()
    
    private lazy var landingPlayButton: MakeButton = {
        let button = MakeButton(image: "play.png", size: CGSize(width: 150, height: 150))
        button.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        return button
    }()
    
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "landing.png")
        backgroundImage.contentMode = .scaleToFill
        view.insertSubview(backgroundImage, at: 0)
        
        view.addSubview(landingTextView)
        
        view.addSubview(landingLogoImage)
        view.addSubview(landingButtonStackView)
        view.addSubview(landingPlayButton)
        // Do any additional setup after loading the view.
        
        setUpAutoLayout()
        
        AudioBGMPlayer.shared.playLanding()
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func collectionTapped() {
        coordinator?.tapCollection()
        AudioSFXPlayer.shared.playCommonSFX()
    }
    
    @objc
    func aboutTapped() {
        coordinator?.tapAbout()
        AudioSFXPlayer.shared.playCommonSFX()
    }
    
    @objc
    func playTapped() {
        coordinator?.tapPlay()
        AudioSFXPlayer.shared.playCommonSFX()
    }
    
    func setUpAutoLayout() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let constant: CGFloat
        
        if screenWidth == 834.0 {
            constant = 250
        } else {
            constant = 300
        }
        
        NSLayoutConstraint.activate([
            
            landingLogoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            landingLogoImage.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1),
            
            landingButtonStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            landingButtonStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            landingButtonStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            landingButtonStackView.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1),
            
            landingPlayButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant),
            landingPlayButton.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1),
            
            landingTextView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant),
        ])
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

