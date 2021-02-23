//
//  ViewController.swift
//  dailyBlitz2.0
//
//  Created by Sullivan Dupre on 6/5/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var currentDeck: cards = cards()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func activate(_ sender: Any) {
        currentDeck.dealCards()
    }
    

}

