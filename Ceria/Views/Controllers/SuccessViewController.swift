//
//  SuccessViewController.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import UIKit

class SuccessViewController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var continueStoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func toStory(_ sender: Any) {
        coordinator?.toStory()
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
