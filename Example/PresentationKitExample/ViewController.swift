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
    
    @IBAction func presentAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert controller", message: "alert message", preferredStyle: .alert)
        alert.addAction(.AlertAction(title: "action", style: .cancel, handler: { (action) in
            print("alert")
        }))
        alert.addAction(.AlertAction(title: "a", style: .default, handler: { (a) in
            
        }))
        
        alert.addTextField { (field) in
            field.isSecureTextEntry = true
        }
        
        alert.present(animated: true)        
    }
}
