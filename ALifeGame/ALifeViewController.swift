//
//  ALifeViewController.swift
//  ALifeGame
//
//  Created by Yamazaki Mitsuyoshi on 2019/11/24.
//  Copyright © 2019 Yamazaki Mitsuyoshi. All rights reserved.
//

import UIKit

final class ALifeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension UIViewController {
  @IBAction func dismiss(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }
}
