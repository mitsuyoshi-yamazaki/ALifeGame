//
//  ALifeViewController.swift
//  ALifeGame
//
//  Created by Yamazaki Mitsuyoshi on 2019/11/24.
//  Copyright © 2019 Yamazaki Mitsuyoshi. All rights reserved.
//

import UIKit
import WebKit

final class ALifeViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView! {
        didSet {
            if let url = URL.init(string: "https://mitsuyoshi-yamazaki.github.io/ALifeGameJam2019/?art_mode=1&population_size=1000&single_gene=1&mutation_rate=0.03") {
                let request = URLRequest.init(url: url)
                webView.load(request)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension UIViewController {
    @IBAction func dismiss(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
