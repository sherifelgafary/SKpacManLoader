//
//  ViewController.swift
//  SKpacManLoader Demo
//
//  Created by sherif on 7/12/17.
//  Copyright © 2017 Sherif Khaled. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        startLoadingIn(self, withBackGround: true, withPacManColor: UIColor.brown, withDotsColor: UIColor.brown)
        finishLoadingFrom(self)
    }


}

