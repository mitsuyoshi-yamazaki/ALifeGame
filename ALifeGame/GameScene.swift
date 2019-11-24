//
//  GameScene.swift
//  ALifeGame
//
//  Created by Yamazaki Mitsuyoshi on 2019/11/23.
//  Copyright © 2019 Yamazaki Mitsuyoshi. All rights reserved.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene {
  
  private var crosshairNode: SKNode! {
    return childNode(withName: "//crosshair")
  }

  override func didMove(to view: SKView) {
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touchLocation = touches.first?.location(in: self) else {
      return
    }
    let action = SKAction.move(to: touchLocation, duration:0.4)
    crosshairNode.run(action)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
  }
  
  
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
  }
}
