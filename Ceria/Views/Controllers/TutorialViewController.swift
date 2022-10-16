//
//  TutorialViewController.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import UIKit

class TutorialViewController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var game2Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func game2Tapped(_ sender: Any) {
        coordinator?.toGame2()
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
