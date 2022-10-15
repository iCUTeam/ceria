//
//  StoryViewController.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import UIKit

class StoryViewController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var gameButton: UIButton!
    @IBOutlet weak var dialogueLabel: UILabel!
    
    private let viewModel = StoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupBinders()
        viewModel.getStory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupBinders() {
        viewModel.storyDialogue.bind { [weak self] dialogue in
            self?.dialogueLabel.text = dialogue
        }
    }

    @IBAction func homeTapped(_ sender: Any) {
        //coordinator?.toLanding()
        
        viewModel.nextIndex()
    }
    
    @IBAction func gameTapped(_ sender: Any) {
        //coordinator?.tapGame()
        
        viewModel.previousIndex()
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
