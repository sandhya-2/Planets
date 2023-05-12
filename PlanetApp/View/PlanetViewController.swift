//
//  PlanetViewController.swift
//  PlanetApp
//
//  Created by Sandiya on 11/05/2023.
//

import Foundation
import UIKit

class PlanetViewController: UIViewController {
    
    let nameText: String = "Name: "
    
   private lazy var namelbl: UILabel = {
        let namelbl = UILabel(frame: CGRect(x: 20, y: 30, width:220, height:50))
       namelbl.text = nameText
       return namelbl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(namelbl)
        
    }
}
