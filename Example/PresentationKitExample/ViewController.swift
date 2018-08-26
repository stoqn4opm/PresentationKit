//
//  ViewController.swift
//  Testbr
//
//  Created by Stoyan Stoyanov on 28.07.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit
import PresentationKit

class ViewController: UIViewController {

    @IBAction func present(_ sender: UIButton) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PresentingNavController")
        viewController.present(animated: true, completion: nil)
    }  
}

