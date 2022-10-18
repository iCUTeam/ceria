//
//  CollectionItem.swift
//  Ceria
//
//  Created by Kathleen Febiola Susanto on 18/10/22.
//

import UIKit
import SceneKit

@IBDesignable class CollectionItem: UIView {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemOrigin: UILabel!
    @IBOutlet weak var itemDesc: UITextView!
    @IBOutlet weak var scnView: SCNView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewInit()
    }
    
    func viewInit() {
        let xibView = Bundle.main.loadNibNamed("CollectionItem", owner: self, options: nil)![0] as! UIView
        xibView.frame = self.bounds
        addSubview(xibView)
    }
    
    func setSCNView(scn: String)
    {
        scnView.scene = SCNScene(named: scn)
        scnView.allowsCameraControl = true
    }

}
