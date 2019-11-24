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
  
  private var cameraNode: SKNode! {
    return childNode(withName: "//camera")
  }

  override func didMove(to view: SKView) {
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let node = tappedNode(of: touches) {
      nodeDidTap(node)
    }
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

extension GameScene {
  enum Action: String {
    case readDocumentation = "book_shelf"
    case enterALifeWorld   = "display"
    case checkNotification = "notification" // TODO: implement
    case seeClock          = "clock"
    case seePicture        = "picture"
  }

  private func tappedNode(of touches: Set<UITouch>) -> SKNode? {
    guard let touchLocation = touches.first?.location(in: self) else {
      return nil
    }
    return atPoint(touchLocation)
  }

  private func nodeDidTap(_ node: SKNode) {
    guard let action = Action.init(rawValue: node.name ?? "") else {
      return
    }
    execute(with: action, node: node)
  }

  private func execute(with action: Action, node: SKNode) {
    let action = SKAction.move(to: node.position, duration:0.4)
    cameraNode.run(action)
  }
}
