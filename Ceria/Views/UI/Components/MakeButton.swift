//
//  MakeButton.swift
//  Ceria
//
//  Created by Kevin Gosalim on 13/10/22.
//

import UIKit

class MakeButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var image: String
    var size: CGSize
    
    init(image: String, size: CGSize) {
        self.image = image
        self.size = size
        super.init(frame: .zero)
        self.setup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let customButtonImage = UIImage(named: image)
        let newimage = customButtonImage?.resizedImage(size: size)
        self.setImage(newimage, for: .normal)
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
