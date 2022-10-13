//
//  ClueExploration.swift
//  Ceria
//
//  Created by Ariel Waraney on 11/10/22.
//

import UIKit

@IBDesignable class ClueExploration: UIView {

    @IBOutlet weak var clueImage: UIImageView!
    @IBOutlet weak var clueDescription: UILabel!
    @IBOutlet weak var clueGreyBackView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewInit()
    }
    
    func viewInit() {
        let xibView = Bundle.main.loadNibNamed("ClueExploration", owner: self, options: nil)![0] as! UIView
        xibView.frame = self.bounds
        addSubview(xibView)
    }
    
    
}
