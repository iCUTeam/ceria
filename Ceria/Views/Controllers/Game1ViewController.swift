//
//  Game1ViewController.swift
//  Ceria
//
//  Created by Kathleen Febiola Susanto on 10/10/22.
//

import UIKit

class Game1ViewController: UIViewController, Storyboarded {
    
    //Game 1 detail (Kath was here)
    
    //Timer 15 second
    
    //SceneKit - Swipe Gesture Recognizer (determine logic to detect if when swipe start it is cloud or not)
    // Painting on Ground level (0,0,0)
    // 10 cloud placed 5 point apart by Y and random value of x and z (0, 5, 0) -> (1, 10, 3) (bikin menutupi lukisannya)
    
    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
