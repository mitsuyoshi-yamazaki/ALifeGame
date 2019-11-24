//
//  GameViewController.swift
//  ALifeGame
//
//  Created by Yamazaki Mitsuyoshi on 2019/11/23.
//  Copyright © 2019 Yamazaki Mitsuyoshi. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

final class GameViewController: UIViewController {

  @IBOutlet private weak var sceneView: SKView! {
    didSet {
      sceneView.ignoresSiblingOrder = true
      sceneView.showsFPS = true
      sceneView.showsNodeCount = true
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if let scene = SKScene(fileNamed: "GameScene") {
      // Set the scale mode to scale to fit the window
      scene.scaleMode = .aspectFill
      scene.size = sceneView.frame.size

      // Present the scene
      sceneView.presentScene(scene)
    }
  }

  override var shouldAutorotate: Bool {
    return true
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }
}
