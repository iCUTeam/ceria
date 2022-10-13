//
//  LandingViewController.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import UIKit

class LandingViewController: UIViewController, Storyboarded {

    @IBOutlet weak var collectionButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    private let landingButtonView: LandingView = {
        
        let view = LandingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var collectButton: MakeButton = {
        let button = MakeButton(title: "Collection", color: .blue)
        button.addTarget(self, action: #selector(collectTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var abtButton: MakeButton = {
        let button = MakeButton(title: "About", color: .red)
        button.addTarget(self, action: #selector(abtTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var landingButtonStackView: MakeStackView = {
        let stackV = MakeStackView(spacingValue: 5, subView: [collectButton, abtButton], axisValue: .horizontal, distributionValue: .fillEqually)
        return stackV
    }()
    
    
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(landingButtonView)
        view.addSubview(landingButtonStackView)
        // Do any additional setup after loading the view.
        
        setUpAutoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func collectionTapped(_ sender: Any) {
        coordinator?.tapCollection()
    }
    
    @IBAction func aboutTapped(_ sender: Any) {
        coordinator?.tapAbout()
    }
    
    @IBAction func playTapped(_ sender: Any) {
        coordinator?.tapPlay()
    }
    
    @objc
        func collectTapped() {
            coordinator?.tapCollection()
        }
    
    @objc
        func abtTapped() {
            coordinator?.tapAbout()
        }
    
    func setUpAutoLayout() {
        NSLayoutConstraint.activate([
            landingButtonView.leftAnchor.constraint(equalTo:view.leftAnchor, constant: 20),
            landingButtonView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            landingButtonView.centerYAnchor.constraint(equalToSystemSpacingBelow: view.centerYAnchor, multiplier: 1),
            landingButtonView.heightAnchor.constraint(equalToConstant: view.bounds.size.height/3.3),
            
            landingButtonStackView.leftAnchor.constraint(equalTo:view.leftAnchor, constant: 20),
            landingButtonStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            landingButtonStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
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
