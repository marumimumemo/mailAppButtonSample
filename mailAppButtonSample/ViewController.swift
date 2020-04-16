//
//  ViewController.swift
//  mailAppButtonSample
//
//  Created by satoshi.marumoto on 2020/04/16.
//  Copyright © 2020 satoshi.marumoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func mailAppButtonTapped() {
        let emailAddress = "abc@abc.co.jp"
        URLSchemeHelper.showMailAppSelection(emailAddress: emailAddress, viewController: self)
    }
}

