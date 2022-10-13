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

    enum backgroundColorEnum {
        case blue, red
    }
    
    var title: String
    var color: backgroundColorEnum?
    
    init(title: String, color: backgroundColorEnum?) {
        self.title = title
        super.init(frame: .zero)
        self.color = color
        self.setup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.setTitle(title, for: .normal)
        self.tintColor = .white
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.testForBackgroundColor()
    }
    
    private func testForBackgroundColor() {
        
        switch color {
        case .blue:
            self.backgroundColor = .blue
        case .red:
            self.backgroundColor = .red
        case .none:
            print("none")
        }
        
    }
    

}
