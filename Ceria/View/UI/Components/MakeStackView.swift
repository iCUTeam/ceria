//
//  MakeStackView.swift
//  Ceria
//
//  Created by Kevin Gosalim on 13/10/22.
//

import UIKit

class MakeStackView: UIStackView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    enum axisEnum {
        case horizontal, vertical
    }
    
    enum distributionEnum {
        case fillProportionally, fill, fillEqually
    }
    
    var spacingValue: CGFloat
    var subView: [UIView]
    var axisValue: axisEnum?
    var distributionValue: distributionEnum?
    
    init(spacingValue: CGFloat, subView: [UIView], axisValue: axisEnum?, distributionValue: distributionEnum?) {
        self.spacingValue = spacingValue
        self.subView = subView
        super.init(frame: .zero)
        self.axisValue = axisValue
        self.distributionValue = distributionValue
        self.setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.spacing = spacingValue
        for view in subView {
            self.addArrangedSubview(view)
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.testAxisValue()
        self.testDistributionValue()
        
    }
    
    private func testAxisValue() {
        switch axisValue {
        case .horizontal:
            self.axis = .horizontal
        case .vertical:
            self.axis = .vertical
        default:
            print("none")
        }
    }
    
    private func testDistributionValue() {
        switch distributionValue {
        case .fillProportionally:
            self.distribution = .fillProportionally
        case .fill:
            self.distribution = .fill
        case .fillEqually:
            self.distribution = .fillEqually
        default:
            print("none")
        }
    }

}

