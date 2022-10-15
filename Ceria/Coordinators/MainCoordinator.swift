//
//  MainCoordinator.swift
//  Ceria
//
//  Created by Kevin Gosalim on 13/10/22.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toLanding() {
        let vc = LandingViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func tapAbout() {
        let vc = AboutViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func tapCollection() {
        let vc = CollectionViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func tapPlay() {
        
        // WIP - Logic to differentiate if state is not_started or others. If not_started, then go to Instruction page
        
        let vc = InstructionViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func toStory() {
        let vc = StoryViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func tapGame() {
        
        // WIP - Logic to differentiate the state to select which gameplay page to return
        
        let vc = ExploreViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
}
