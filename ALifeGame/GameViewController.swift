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
    
    private let gameScene: GameScene! = GameScene(fileNamed: "GameScene")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameScene.scaleMode = .aspectFill
        gameScene.size = sceneView.frame.size
        gameScene.gameSceneDelegate = self
        
        sceneView.presentScene(gameScene)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        gameScene.focusPoint = .none
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

extension GameViewController: GameSceneDelegate {
    func gameSceneDidEnterALifeWorld(_ scene: GameScene) {
        performSegue(withIdentifier: "ShowALifeView", sender: self)
    }
}
