//
//  InstructionViewController.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import UIKit

class InstructionViewController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startStoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    @IBAction func backTapped(_ sender: Any) {
        coordinator?.toLanding()
    }
    
    @IBAction func startStoryTapped(_ sender: Any) {
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


//        button.titleLabel?.font = UIFont.scriptFont(size: 30)
