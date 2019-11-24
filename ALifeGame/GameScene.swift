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
  
  private var cameraNode: SKCameraNode! {
    return childNode(withName: "//camera") as? SKCameraNode
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
    let nodePosition = node.convert(node.position, to: self)
    let cameraPosition = positionInScene(nodePosition)
    let action = SKAction.move(to: cameraPosition, duration:0.4)
    cameraNode.run(action)
  }

  private func positionInScene(_ position: CGPoint) -> CGPoint {
    let cameraMaxPosition = CGPoint.init(x: (1334.0 / 4.0) * 1.0, y: 0.0) // TODO: 動的に求める
    let cameraMinPosition = CGPoint.init(x: (1334.0 / 4.0) * -1.0, y: 0.0)

    let positionInScene = max(cameraMinPosition, min(cameraMaxPosition, position))
    print("pos: \(position), \(positionInScene)")

    return positionInScene
  }
}

extension CGSize {
  var coordinateRepresentation: CGPoint {
    return CGPoint.init(x: width, y: height)
  }

  static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize.init(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
  }

  static func -(lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize.init(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
  }

  static func *(size: CGSize, constant: CGFloat) -> CGSize {
    return CGSize.init(width: size.width * constant, height: size.height * constant)
  }

  static func /(size: CGSize, constant: CGFloat) -> CGSize {
    return CGSize.init(width: size.width / constant, height: size.height / constant)
  }
}

func max(_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
  return CGPoint.init(x: max(lhs.x, rhs.x), y: max(lhs.y, rhs.y))
}

func min(_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
  return CGPoint.init(x: min(lhs.x, rhs.x), y: min(lhs.y, rhs.y))
}
