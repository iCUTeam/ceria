//
//  InstructionViewController.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import UIKit
import SceneKit

class InstructionViewController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    
    private lazy var homeButton: MakeButton = {
        let button = MakeButton(image: "home.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var startStoryButton: MakeButton = {
        let button = MakeButton(image: "startstory.png", size: CGSize(width: 290, height: 78))
        button.addTarget(self, action: #selector(startStoryTapped), for: .touchUpInside)
        return button
    }()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeButton)
        view.addSubview(startStoryButton)
      
        setUpAutoLayout()
        // Do any additional setup after loading the view.
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
    
    @objc
        func startStoryTapped() {
            var state = defaults.string(forKey: "userState")
            switch state {
            case "clear_story_1":
                coordinator?.toExplore()
                sleep(3)
            case "clear_story_2":
                coordinator?.toPower()
            case "clear_story_3":
                coordinator?.toTutorial()
            case "clear_story_4":
                coordinator?.toExplore()
                sleep(3)
            case "cleared":
                coordinator?.toReflection()
            default:
                coordinator?.toStory()
            }
            
            AudioSFXPlayer.shared.playCommonSFX()
            AudioBGMPlayer.shared.stopLanding()
        }
    
    func setUpAutoLayout() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let constant: CGFloat
       
        if screenWidth == 834.0 {
            constant = 500
        } else {
            constant = 580
        }
        
        NSLayoutConstraint.activate([
            homeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            homeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
            startStoryButton.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1),
            startStoryButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant),
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



